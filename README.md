# Horta Comunitária VerdeVida

## Descrição
O banco de dados da Horta Comunitária foi desenvolvido para gerenciar informações de **voluntários, hortas, cultivos e doações**. Cada entidade possui uma tabela dedicada, com chaves primárias únicas e relacionamentos através de chaves estrangeiras, garantindo integridade e consistência dos dados. Densevolvido com banco de dados MySQL.

- **Voluntário**: registra informações pessoais e permite associar doações realizadas.  
- **Horta**: identifica os espaços de cultivo.  
- **Cultivo**: controla o que é plantado em cada horta, incluindo datas de plantio.  
- **Doação**: registra recursos doados por voluntários, incluindo valores e datas.

O modelo físico implementa relacionamentos 1:N, funções agregadas e consultas SQL que facilitam análises e relatórios do sistema.
