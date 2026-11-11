--- Inserção de dados
INSERT INTO "Cliente" ("nome", "cpf") VALUES
  ('Ana Souza', '111.111.111-11'),
  ('Bruno Lima', '222.222.222-22'),
  ('Carla Mendes', '333.333.333-33');

INSERT INTO "Veterinario" ("nome", "cpf", "crmv", "especialidade") VALUES
  ('Dra. Mariana Alves', '444.444.444-44', 'CRMV-BA-1001', 'Clinica geral'),
  ('Dr. Rafael Costa', '555.555.555-55', 'CRMV-BA-1002', 'Dermatologia');

INSERT INTO "Paciente" ("nome", "especie", "raca", "cliente_id") VALUES
  ('Luna', 'Cao', 'Shih-tzu', 1),
  ('Thor', 'Cao', 'Golden Retriever', 1),
  ('Mimi', 'Gato', 'Siames', 2),
  ('Nina', 'Gato', 'Persa', 3),
  ('Bidu', 'Cao', 'Beagle', 3);

INSERT INTO "Procedimento" ("nome", "descricao", "valor_base") VALUES
  ('Consulta clinica', 'Avaliacao clinica geral do paciente.', 120.00),
  ('Vacinacao', 'Aplicacao de vacina conforme protocolo.', 80.00),
  ('Exame de sangue', 'Coleta e analise de sangue.', 150.00),
  ('Limpeza dentaria', 'Procedimento de higiene e limpeza bucal.', 250.00);

INSERT INTO "Consulta" ("data_marcada", "status", "vet_id", "paciente_id") VALUES
  ('2026-11-10 09:00:00', 'FINALIZADA', 1, 1),
  ('2026-11-10 10:30:00', 'FINALIZADA', 2, 3),
  ('2026-11-11 14:00:00', 'MARCADA', 1, 2),
  ('2026-11-12 08:30:00', 'CANCELADA', 2, 4),
  ('2026-11-12 16:00:00', 'MARCADA', 1, 1);

INSERT INTO "Procedimento_Consulta" ("consulta_id", "procedimento_id", "valor_cobrado", "observacoes") VALUES
  (1, 1, 120.00, 'Paciente em boas condicoes gerais.'),
  (1, 2, 80.00, 'Reforco anual aplicado.'),
  (2, 1, 120.00, 'Avaliacao dermatologica inicial.'),
  (2, 3, 150.00, 'Solicitado hemograma.'),
  (3, 1, 120.00, NULL),
  (4, 1, 120.00, 'Consulta cancelada pelo cliente.');
