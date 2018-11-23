pragma solidity ^0.5.0;

contract Voting {

    mapping (string => uint8) candidateList;
    mapping (uint8 => uint32) votesReceived;
    mapping (address => uint8) whiteList;
    uint32 initTime;
    uint32 durationTime;

    function totalVotesFor(uint8 candidate) public view returns (uint32){
        require(validCandidate(candidate));
        return votesReceived[candidate];
    }

    function voteForCandidate(uint8 candidate) public {
        require(validCandidate(candidate));
        votesReceived[candidate] += 1;
    }

    function validCandidate(uint8 candidate) public view returns (bool) {
        for(uint i = 0; i < candidateList.length; i++) {
        if (candidateList[i] == candidate) {
            return true;
          }
    }
        return false;
    }

    function getCandidateList() public view returns (bytes32[] memory) {
        return candidateList;
    }
}
