var Certification = artifacts.require("./Certification.sol");
var Institution = artifacts.require("./Institution.sol");

module.exports = async function(deployer) {
  // deployer.deploy(Certification);

  // Deploy Institution Contract
  await deployer.deploy(Institution, {gas: 6721975})
  const institution = await Institution.deployed()

  // Deploy Certification Contract
  await deployer.deploy(Certification, "0xae5677f490adb50e6579645e53ac48207a53a3b1")
  const certification = await Certification.deployed()
};
