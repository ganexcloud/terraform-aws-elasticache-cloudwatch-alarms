# Evidências Fase 1: terraform-aws-elasticache-cloudwatch-alarms

Data: 2026-08-10 BRT.

## Baselines offline

| Origem | SHA | Comando | Resultado |
| --- | --- | --- | --- |
| Memcached | `09cee6d8da030f8ba5fed67cc9087b952112286b` | `terraform plan -refresh=false` com dois IDs e credenciais sintéticas | 10 alarmes em `planned-values-terraform-aws-elasticache-memcached-cloudwatch-alarms-baseline.json` |
| Redis | `d2ffdb33a96072041c903685ec7c5f067840964a` | `terraform plan -refresh=false` com dois IDs e credenciais sintéticas | 16 alarmes em `planned-values-terraform-aws-elasticache-redis-cloudwatch-alarms-baseline.json` |

O patch aplicado somente nas cópias efêmeras substitui a leitura obrigatória de `aws_iam_account_alias` por `alarm_name_prefix = title(var.alarm_name_prefix)`. Cada fixture passou `alarm_name_prefix=ganex`, preservando o prefixo que a leitura teria produzido no cenário. Também contém provider AWS com região e credenciais sintéticas, validações de credencial, metadata, região e account ID desabilitadas. Nenhuma chamada AWS foi realizada.

## Scanner

- Ferramenta: Trivy `0.73.0`, binário em `/tmp/ganex-ops-tools/trivy-0.73.0/trivy`.
- Integridade: SHA-256 `2edd39da482bb4e9831962487b68f68e3928ec3137794757f54d00383d79547b`, conferido contra o checksum oficial da release.
- Política: check bundle em cache, digest `sha256:1583562f8b90ed2a071b99f0e5ffff6b57e4ceb6ca3e4796577b4e6a339eb74c`.
- Execuções: `trivy config --format json` nas duas origens.
- Findings: Memcached 0, Redis 0.
- Limitação: o scanner avisou que as variáveis obrigatórias não estavam em ambiente ou arquivos de variável. Isso é esperado para módulos reutilizáveis e a mesma ferramenta, versão e bundle serão usados no pós para validade do delta.
