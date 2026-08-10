# Evidências Fase 2: terraform-aws-elasticache-cloudwatch-alarms

Data: 2026-08-10 BRT. Autor da aprovação do plano: Caio Henrique.

## Escopo executado

- Criado o repositório público `ganexcloud/terraform-aws-elasticache-cloudwatch-alarms` após confirmação de inexistência.
- Baseline `v0.1.0` publicada no GitHub com os históricos Memcached e Redis preservados; os SHAs estão em `MIGRATION-SOURCES.md`.
- Branch de implementação: `modernize/elasticache-alarms`.
- Plano, TODO e evidências/baselines da Fase 1 estão anexados em `docs/migration/`.
- Consumidores, states, backends e contas AWS não foram consultados nem alterados. As origens GitLab não foram arquivadas.

## Validação estrutural

| Verificação | Resultado |
| --- | --- |
| `terraform fmt -check -recursive` | verde |
| `terraform init -backend=false` | verde; AWS provider `6.58.0` |
| `terraform validate` | verde |
| `terraform test -verbose` | 3 testes aprovados; 0 falhas |
| `tflint --recursive` | verde; sem issues |
| `pre-commit run --all-files` | verde (fmt e validate) |
| Trivy `0.73.0`, bundle `sha256:1583562f...` | 0 findings novos; 0 falhas IaC |

## Contrato e comportamento

- Fixture Memcached com dois IDs: 10 alarmes, endereços `count` preservados. `SwapUsage`, `Evictions`/`Sum` e `BytesUsedForCacheItems`/`Average` foram assertados; o threshold em bytes é obrigatório.
- Fixture Redis com dois IDs: 16 alarmes, incluindo EngineCPU e bandwidth; memória usa `DatabaseMemoryUsagePercentage`.
- Os endereços internos continuam `aws_cloudwatch_metric_alarm.<nome>[index]`, sem `for_each`, `moved` ou mudança de cardinalidade para os caminhos cobertos.
- Snapshots pós-plan estão em `docs/migration/fase2/`; os baselines correspondentes estão em `docs/migration/fase1/`.
- A PR #1 executou o workflow remoto `validate` com sucesso (runs `31426271829` e `31426422759`). A proteção clássica de `main` está ativa, exigindo PR e check `validate`, sem force-push/deleção e com admins sujeitos à proteção; não há aprovação adicional obrigatória.

## Gate pendente

Não foi executado merge para `main`, não foi executada publicação no Terraform Registry, e nenhuma origem GitLab foi arquivada. A confirmação separada de irreversibilidade solicitada pelo operador é necessária antes do merge que dispara o Semantic Release/Registry. Ruleset da organização/GitHub App, aprovação humana da PR, Registry e arquivamento permanecem pendentes.
