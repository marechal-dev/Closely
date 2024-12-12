-- name: GetCompanyByLegalEntityID :one
SELECT
	id,
	title,
	legal_entity_id,
	location,
	created_at,
	modified_at,
	deleted_at
FROM companies
	WHERE legal_entity_id = $1 LIMIT 1;

-- name: CreateCompany :one
INSERT INTO companies (
	title,
	legal_entity_id,
	location
) VALUES (
	$1, $2, $3
) RETURNING *;

