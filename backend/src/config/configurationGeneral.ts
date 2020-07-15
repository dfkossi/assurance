export * from 'child_process';
export const configurationGeneral = {
  sqlstore: {
    datasource: {
      username: process.env.POSTGRES_USER || 'postgres',
      password: process.env.POSTGRES_PASSWORD || 'postgres',
      connector: 'postgresql',
      host: process.env.POSTGRES_HOST || 'postgres',
      port: 5432,
      database: 'postgres',
    },
  },
  logger: {
    level: 'debug',
    pattern: '[%d] [%p] %c - %m',
  },

  fabricNetworkConfiguration: {
    localMspId: process.env.CORE_PEER_LOCALMSPID,
    mspConfigPath:
      process.env.TELEPRESENCE_CONTAINER_NAMESPACE != undefined
        ? './src/config/cryptogen/msp'
        : process.env.CORE_USER_MSP_CONFIGPATH,
    commonConnectionProfilePath:
      process.env.KUBERNETES_SERVICE_HOST === undefined
        ? './config/network-config-local.yaml'
        : './config/network-config.yaml',
    network: 'myc',
    chaincodeId: 'mycc',
  },
};
export default configurationGeneral;

console.log(
  'process.env.CORE_USER_MSP_CONFIGPATH',
  process.env.CORE_USER_MSP_CONFIGPATH,
);
console.log(
  'process.env.CORE_PEER_LOCALMSPID',
  process.env.CORE_PEER_LOCALMSPID,
);
console.log(
  'process.env.TELEPRESENCE_CONTAINER_NAMESPACE',
  process.env.TELEPRESENCE_CONTAINER_NAMESPACE,
);
