pragma solidity ^0.5.0;

contract Voting {
    
    bytes32[] candidateList;
    mapping (bytes32 => uint32) votesReceived;
    mapping (address => uint8) whiteList;
    uint initTime;
    uint32 durationTimeMin;
    
    constructor(uint32 _durationTimeMin, bytes32[] memory _candidateList ,address[] memory _adresses) public {
        candidateList = _candidateList;
        initTime = now;
        durationTimeMin = _durationTimeMin;
        for (uint i = 0; i < _adresses.length; i++) {
            whiteList[_adresses[i]] = 1;
        }
    }

    function totalVotesFor(bytes32 candidate) public view returns (uint32){
        require(validCandidate(candidate));
        return votesReceived[candidate];
    }

    function voteForCandidate(bytes32 candidate) public {
        require(validCandidate(candidate));
        require(validVoter(msg.sender));
        require(validTime());
        votesReceived[candidate] += 1;
        whiteList[msg.sender] = 2;
    }

    function validCandidate(bytes32 candidate) public view returns (bool) {
        for (uint i = 0; i < candidateList.length; i++) {
        if (candidateList[i] == candidate) {
            return true;
          }
    }
        return false;
    }
    
    function validVoter(address voter) public view returns (bool) {
        if (whiteList[voter] == 1) {
            return true;
        }
        return false;
    }
    
    function validTime() public view returns (bool) {
        if (now < initTime + durationTimeMin * 1 minutes) {
            return true;
        }
        return false;
    }

    function getCandidateList() public view returns (bytes32[] memory) {
        return candidateList;
    }
}

