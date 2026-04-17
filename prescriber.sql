---Q1 A


SELECT npi, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY npi
ORDER BY total_claims DESC


--Q2 B


SELECT DISTINCT  nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count
FROM prescriber INNER JOIN prescription ON prescriber.npi = prescription.npi
ORDER BY total_claim_count DESC



--q2 A


SELECT specialty_description
FROM prescriber



 SELECT *
 FROM prescriber


SELECT *
FROM prescription