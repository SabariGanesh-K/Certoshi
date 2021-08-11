pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./Institution.sol";

contract Certification {
    // State Variables
    address public owner;
    Institution public institution;

    // Mappings
    mapping(bytes32 => Certificate) private certificates;

    // Events
    event certificateGenerated(bytes32 _certificateId);

    constructor(Institution _institution) public {
        owner = msg.sender;
        institution = _institution;
    }

    struct Certificate {
        // Individual Info
        string candidate_name;
        string course_name;
        uint256 creation_date;

        // Institute Info
        string institute_name;
        string institute_acronym;
        string institute_link;

        // Revocation status
        bool revoked;
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
                result := mload(add(source, 32))
        }
    }

    function generateCertificate(
        string memory _id,
        string memory _candidate_name,
        uint256 _course_index, 
        uint256 _creation_date) public {
        require(institution.checkInstitutePermission(msg.sender) == true, "Institute account does not exist");
        bytes32 byte_id = stringToBytes32(_id);
        require(certificates[byte_id].creation_date == 0, "Certificate with given id already exists");
        (string memory _institute_name, string memory _institute_acronym, string memory _institute_link, Institution.Course[] memory _institute_courses) = institution.getInstituteData(msg.sender);
        require(_course_index >= 0 && _course_index < _institute_courses.length, "Invalid Course index");
        string memory _course_name = _institute_courses[_course_index].course_name;
        bool revocation_status = false;
        certificates[byte_id] = Certificate(_candidate_name, _course_name, _creation_date, _institute_name, _institute_acronym, _institute_link, revocation_status);
        emit certificateGenerated(byte_id);
    }

    function getData(string memory _id) public view returns(string memory, string memory, uint256, string memory, string memory, string memory, bool) {
        bytes32 byte_id = stringToBytes32(_id);
        Certificate memory temp = certificates[byte_id];
        require(certificates[byte_id].creation_date != 0, "Certificate id does not exist!");
        return (temp.candidate_name, temp.course_name, temp.creation_date, temp.institute_name, temp.institute_acronym, temp.institute_link, temp.revoked);
    }
}