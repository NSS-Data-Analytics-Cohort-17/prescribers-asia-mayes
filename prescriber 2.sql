---Q1 A


SELECT npi, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY npi
ORDER BY total_claims DESC


--Q2 B


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



 SELECT *
 FROM prescriber


SELECT *
FROM prescription