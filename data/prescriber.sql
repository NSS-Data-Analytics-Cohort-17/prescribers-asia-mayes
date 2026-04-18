---Q1 A


SELECT npi, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY npi
ORDER BY total_claims DESC;


--Q1 B


SELECT DISTINCT  nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count
FROM prescriber INNER JOIN prescription ON prescriber.npi = prescription.npi
ORDER BY total_claim_count DESC



--Q2 A


SELECT specialty_description, SUM(total_claim_count) AS total_claims
FROM prescriber INNER JOIN prescription ON prescriber.npi = prescription.npi
GROUP BY specialty_description
ORDER BY total_claims DESC;

--Q2 B

SELECT specialty_description, SUM(total_claim_count) AS total_claims
FROM prescriber INNER JOIN prescription ON prescriber.npi = prescription.npi
				INNER JOIN drug ON  prescription.drug_name = drug.drug_name
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY total_claims DESC;



--Q2 (C)

SELECT specialty_description
FROM prescriber
LEFT JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescription.npi IS NULL



--Q2 (D)

SELECT specialty_description, SUM(CASE WHEN opioid_drug_flag = 'Y' THEN total_claim_count ELSE 0 END) * 100.0 / SUM(total_claim_count)  > 0.5 AS opioid_percentage
FROM prescriber JOIN prescription ON prescriber.npi = prescription.npi
				JOIN drug ON prescription.drug_name = drug.drug_name
GROUP BY specialty_description
ORDER BY opioid_percentage DESC;



---Q3 (A)

SELECT generic_name, SUM(total_drug_cost) AS total_cost
FROM drug JOIN prescription ON prescription.drug_name = drug.drug_name
GROUP BY generic_name
ORDER BY total_cost DESC;



---Q3 (B)


SELECT generic_name, ROUND(SUM(total_drug_cost) * 1.0  / NULLIF(SUM(total_day_supply), 0), 2)::MONEY AS cost_per_day
FROM drug JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY  generic_name
ORDER BY cost_per_day DESC;




--Q4 (A)

SELECT drug_name,
CASE
	WHEN opioid_drug_flag = 'Y' AND antibiotic_drug_flag ='Y' THEN 'both'
	WHEN opioid_drug_flag ='Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither'
END AS drug_type
FROM drug;



--Q4(B)


SELECT 
CASE 
	WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither'
END AS drug_type,
ROUND(SUM(total_drug_cost), 2) AS total_cost
FROM drug
JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY
CASE
	WHEN opioid_drug_flag = 'Y' THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither'
END 
ORDER BY total_cost DESC;



--Q5(A)

SELECT cbsaname, 
	COUNT(DISTINCT cbsa) AS num_cbsas
FROM cbsa
WHERE cbsaname LIKE '%, TN%'
	OR cbsaname LIKE '% TN-%'
GROUP BY cbsaname;




---Q5(B)

SELECT cbsa,
	cbsaname,
	SUM(population) AS total_population
FROM cbsa JOIN population ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa, cbsaname
ORDER BY total_population DESC;




SELECT cbsa,
	cbsaname,
	SUM(population) AS total_population
FROM cbsa JOIN population ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa, cbsaname
ORDER BY total_population ASC;




--Q5(C)


SELECT county, population
FROM fips_county
JOIN population ON fips_county.fipscounty = population.fipscounty
LEFT JOIN cbsa ON fips_county.fipscounty = cbsa.fipscounty
WHERE cbsa.fipscounty IS NULL
ORDER BY population.population DESC
LIMIT 1;




--Q6(A)


SELECT drug_name, total_claim_count AS total_claims
FROM prescription
WHERE total_claim_count >= 3000;


--Q6(B)


SELECT prescription.drug_name, prescription.total_claim_count AS total_claims,
	CASE 
		WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
		ELSE 'not opioid'
	END AS opioid_status
FROM prescription
JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescription.total_claim_count >= 3000;


---Q6(C)


SELECT prescription.drug_name, prescription.total_claim_count AS total_claims,
	CASE 
		WHEN drug.opioid_drug_flag = 'Y' THEN 'opioid'
		ELSE 'not opioid'
	END AS opioid_status, prescriber.nppes_provider_first_name AS first_name, prescriber.nppes_provider_last_org_name AS last_name
FROM prescription
JOIN drug ON prescription.drug_name = drug.drug_name
JOIN prescriber ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count >= 3000;


--Q7(A)

SELECT prescriber.npi, drug.drug_name
FROM prescriber
CROSS JOIN drug
WHERE prescriber.specialty_description ='Pain Management'
	AND prescriber.nppes_provider_city ='NASHVILLE'
	AND drug.opioid_drug_flag = 'Y';



--Q7(B)


SELECT prescriber.npi, drug.drug_name, SUM(COALESCE(prescription.total_claim_count, 0)) AS total_claim_count
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription ON prescription.npi = prescriber.npi AND prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description ='Pain Management'
	AND prescriber.nppes_provider_city = 'NASHVILLE'
	AND drug.opioid_drug_flag ='Y'
GROUP BY prescriber.npi, drug.drug_name
ORDER BY total_claim_count DESC;





