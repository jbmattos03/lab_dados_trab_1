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



--- 1. Pacientes e seus responsáveis (INNER JOIN)
SELECT p."nome"    AS paciente,
       p."especie",
       p."raca",
       c."nome"    AS cliente
FROM "Paciente" p
INNER JOIN "Cliente" c ON c."id" = p."cliente_id"
ORDER BY c."nome", p."nome";

--- 2. Agenda completa: consulta, paciente, cliente e veterinário (INNER JOIN)
SELECT co."id"           AS consulta,
       co."data_marcada",
       co."status",
       p."nome"          AS paciente,
       c."nome"          AS cliente,
       v."nome"          AS veterinario
FROM "Consulta" co
INNER JOIN "Paciente" p    ON p."id" = co."paciente_id"
INNER JOIN "Cliente" c     ON c."id" = p."cliente_id"
INNER JOIN "Veterinario" v ON v."id" = co."vet_id"
ORDER BY co."data_marcada";

--- 3. Procedimentos de cada consulta, com valor base e valor cobrado (N:N)
SELECT co."id"            AS consulta,
       p."nome"           AS paciente,
       pr."nome"          AS procedimento,
       pr."valor_base",
       pc."valor_cobrado",
       pc."observacoes"
FROM "Procedimento_Consulta" pc
INNER JOIN "Consulta" co     ON co."id" = pc."consulta_id"
INNER JOIN "Procedimento" pr ON pr."id" = pc."procedimento_id"
INNER JOIN "Paciente" p      ON p."id" = co."paciente_id"
ORDER BY co."id", pr."nome";

--- 4. Consultas ainda marcadas (filtro por status)
SELECT co."id"           AS consulta,
       co."data_marcada",
       p."nome"          AS paciente,
       v."nome"          AS veterinario
FROM "Consulta" co
INNER JOIN "Paciente" p    ON p."id" = co."paciente_id"
INNER JOIN "Veterinario" v ON v."id" = co."vet_id"
WHERE co."status" = 'MARCADA'
ORDER BY co."data_marcada";

--- 5. Pacientes sem nenhuma consulta (LEFT JOIN)
SELECT p."nome" AS paciente,
       c."nome" AS cliente
FROM "Paciente" p
INNER JOIN "Cliente" c  ON c."id" = p."cliente_id"
LEFT JOIN "Consulta" co ON co."paciente_id" = p."id"
WHERE co."id" IS NULL;

--- 6. Procedimentos que nunca foram realizados (LEFT JOIN)
SELECT pr."nome",
       pr."valor_base"
FROM "Procedimento" pr
LEFT JOIN "Procedimento_Consulta" pc ON pc."procedimento_id" = pr."id"
WHERE pc."consulta_id" IS NULL;

--- 7. Quantidade de consultas por paciente, incluindo quem não tem (LEFT JOIN + GROUP BY)
SELECT p."nome"       AS paciente,
       COUNT(co."id") AS total_consultas
FROM "Paciente" p
LEFT JOIN "Consulta" co ON co."paciente_id" = p."id"
GROUP BY p."id", p."nome"
ORDER BY total_consultas DESC, p."nome";

--- 8. Quantidade de pacientes por cliente (GROUP BY)
SELECT c."nome"      AS cliente,
       COUNT(p."id") AS total_pacientes
FROM "Cliente" c
LEFT JOIN "Paciente" p ON p."cliente_id" = c."id"
GROUP BY c."id", c."nome"
ORDER BY total_pacientes DESC, c."nome";

--- 9. Valor total de cada consulta finalizada (SUM)
SELECT co."id"                 AS consulta,
       co."data_marcada",
       p."nome"                AS paciente,
       COUNT(*)                AS qtd_procedimentos,
       SUM(pc."valor_cobrado") AS valor_total
FROM "Consulta" co
INNER JOIN "Paciente" p               ON p."id" = co."paciente_id"
INNER JOIN "Procedimento_Consulta" pc ON pc."consulta_id" = co."id"
WHERE co."status" = 'FINALIZADA'
GROUP BY co."id", co."data_marcada", p."nome"
ORDER BY co."id";

--- 10. Uso e faturamento de cada procedimento em consultas finalizadas (LEFT JOIN + COALESCE)
SELECT pr."nome"                            AS procedimento,
       COUNT(co."id")                       AS vezes_realizado,
       COALESCE(SUM(pc."valor_cobrado"), 0) AS faturamento
FROM "Procedimento" pr
LEFT JOIN (
  "Procedimento_Consulta" pc
  INNER JOIN "Consulta" co ON co."id" = pc."consulta_id"
                          AND co."status" = 'FINALIZADA'
) ON pc."procedimento_id" = pr."id"
GROUP BY pr."id", pr."nome"
ORDER BY faturamento DESC, pr."nome";

--- 11. Consultas por veterinário e por status (GROUP BY com duas colunas)
SELECT v."nome"     AS veterinario,
       co."status",
       COUNT(*)     AS total
FROM "Veterinario" v
INNER JOIN "Consulta" co ON co."vet_id" = v."id"
GROUP BY v."nome", co."status"
ORDER BY v."nome", co."status";