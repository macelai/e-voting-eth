pragma solidity ^0.5.0;

contract Voting {

    struct Candidate {
        bytes32 name;
        uint16 party;
        uint32 voteCount;
    }

    mapping (uint16 => Candidate) candidates;
    mapping (address => uint16) whiteList;
    // Timestamp
    uint initTime;
    uint durationTimeMin;

    function setTime(uint _initTime, uint _durationTime) public {
        initTime = _initTime;
        durationTimeMin = _durationTime;
    }

    function addToWhiteList(address _address) public {
        require(validTimeToAdd());
        // To know it's first time voting
        whiteList[_address] = 999;
    }

    function addCandidate(bytes32 _name, uint8 _party) public {
        require(validTimeToAdd());
        require(0 < _party);
        require(100 > _party);
        Candidate memory newCandidate = Candidate({name: _name, party: _party, voteCount: 0});
        candidates[newCandidate.party] = newCandidate;
    }

    function totalVotesFor(uint16 candidate) public view returns (uint32){
        require(validCandidate(candidate));
        return candidates[candidate].voteCount;
    }

    function voteForCandidate(uint16 candidate) public {
        require(validCandidate(candidate));
        require(validVoter(msg.sender));
        require(validTimeToVote());
        // Not the first time voting
        if (whiteList[msg.sender] != 999) {
            candidates[whiteList[msg.sender]].voteCount--;
        }
        candidates[candidate].voteCount++;
        whiteList[msg.sender] = candidate;
    }

    function validTimeToAdd() public view returns (bool) {
        if (initTime >= now) {
            return true;
        }
        return false;
    }

    function validCandidate(uint16 candidate) public view returns (bool) {
        if (candidates[candidate].party == candidate) {
            return true;
        }
        return false;
    }

    function validVoter(address voter) public view returns (bool) {
        if (whiteList[voter] != 0) {
            return true;
        }
        return false;
    }

    function validTimeToVote() public view returns (bool) {
        if (now <= durationTimeMin && now >= initTime) {
            return true;
        }
        return false;
    }

}


