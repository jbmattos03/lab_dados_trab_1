-- Q1. Filtro com WHERE e ordenação com ORDER BY
-- Regra 2: cada consulta deve ter o status como MARCADA, CANCELADA OU FINALIZADA
SELECT * 
FROM "Consulta"
WHERE "status" = 'MARCADA'
ORDER BY "data_marcada";
-- Q2. Consulta com INNER JOIN
-- Regra 2: cada consulta deve estar relacionada a um paciente e um veterinário.
SELECT p."nome" as "nome_paciente", p."especie", v."nome" as "nome_veterinario",c."data_marcada",c."status"
FROM "Consulta" c
INNER JOIN "Paciente" p
ON p."id" = c."paciente_id"
INNER JOIN "Veterinario" v
ON v."id" = c."vet_id";
-- Q3. Consulta com LEFT JOIN
-- Q4. Cálculo de subtotal por quantidade × valor unitário.
-- Regra 3: um procedimento pode estar em várias consultas e uma consulta pode ter vários procedimentos.
SELECT SUM(p."valor_base") as "valor_consulta", pc."consulta_id", COUNT(*) as qdt_procedimentos_consulta
FROM "Procedimento_Consulta" pc
JOIN "Procedimento" p
ON p."id"=pc."procedimento_id"
JOIN "Consulta" c
ON c."id"= pc."consulta_id"
WHERE c."status" = 'FINALIZADA'
GROUP BY pc."consulta_id";