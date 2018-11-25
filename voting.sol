pragma solidity ^0.5.0;

contract Voting {
    
    struct Candidate {
        bytes32 name;
        uint8 party;
        uint32 voteCount;
    }

    mapping (uint8 => Candidate) candidates;
    mapping (address => uint8) whiteList;
    uint initTime;
    uint32 durationTimeMin;
    
    constructor(uint32 _durationTimeMin) public {
        initTime = now;
        durationTimeMin = _durationTimeMin;
    }
    
    function addToWhiteList(address _address) public{
        whiteList[_address] = 1;
    }
    
    function addCandidate(bytes32 _name, uint8 _party) public {
        Candidate memory newCandidate = Candidate({name: _name, party: _party, voteCount: 0}); 
        candidates[newCandidate.party] = newCandidate;
    }

    function totalVotesFor(uint8 candidate) public view returns (uint32){
        require(validCandidate(candidate));
        return candidates[candidate].voteCount;
    }

    function voteForCandidate(uint8 candidate) public {
        require(validCandidate(candidate));
        require(validVoter(msg.sender));
        require(validTime());
        candidates[candidate].voteCount ++;
        whiteList[msg.sender] = 2;
    }

    function validCandidate(uint8 candidate) public view returns (bool) {
        if (candidates[candidate].party == candidate) {
            return true;
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
    
}

