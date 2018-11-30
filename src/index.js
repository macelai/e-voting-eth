(() => {
  const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
  const interface = ([
	{
		"constant": false,
		"inputs": [
			{
				"name": "_name",
				"type": "string"
			},
			{
				"name": "_party",
				"type": "uint8"
			}
		],
		"name": "addCandidate",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_address",
				"type": "address"
			}
		],
		"name": "addToWhiteList",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_initTime",
				"type": "uint256"
			},
			{
				"name": "_durationTime",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "candidate",
				"type": "uint16"
			}
		],
		"name": "voteForCandidate",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint16"
			}
		],
		"name": "candidates",
		"outputs": [
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "party",
				"type": "uint16"
			},
			{
				"name": "voteCount",
				"type": "uint32"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "durationTimeMin",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "initTime",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "candidate",
				"type": "uint16"
			}
		],
		"name": "totalVotesFor",
		"outputs": [
			{
				"name": "",
				"type": "uint32"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "candidate",
				"type": "uint16"
			}
		],
		"name": "validCandidate",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "validTime",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "validTimeToAdd",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "voter",
				"type": "address"
			}
		],
		"name": "validVoter",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "whiteList",
		"outputs": [
			{
				"name": "",
				"type": "uint16"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]);
  const VotingContract = web3.eth.contract(interface);
  const contractInstance = VotingContract.at('0x3adec93904ac5469b2225bb7d97f934aaa295640');

  web3.personal.unlockAccount(web3.eth.accounts[0], '123qwe', 0);

  const tableElem = document.getElementById("table-body");
  const candidateOptions = document.getElementById("candidate-options");
  const voteForm = document.getElementById("vote-form");

  function handleVoteForCandidate(evt) {
    const candidate = new FormData(evt.target).get("candidate");
    contractInstance.voteForCandidate(candidate, {from: web3.eth.accounts[0]}, function() {
      const votes = contractInstance.totalVotesFor.call(candidate);

      // Updates the vote element.
      document.getElementById("vote-" + candidate).innerText = votes;
    });
  }

  voteForm.addEventListener("submit", handleVoteForCandidate, false);

  function populateCandidates() {
    const candidateList = contractInstance.getCandidateList.call(); // call() is used for sync read only calls.
    candidateList.forEach((candidate) => {
      const candidateName = web3.toUtf8(candidate);
      const votes = contractInstance.totalVotesFor.call(candidate);

      // Creates a row element.
      const rowElem = document.createElement("tr");

      // Creates a cell element for the name.
      const nameCell = document.createElement("td");
      nameCell.innerText = candidateName;
      rowElem.appendChild(nameCell);

      // Creates a cell element for the votes.
      const voteCell = document.createElement("td");
      voteCell.id = "vote-" + candidate; 
      voteCell.innerText = votes;
      rowElem.appendChild(voteCell);

      // Adds the new row to the voting table.
      tableElem.appendChild(rowElem);

      // Creates an option for each candidate
      const candidateOption = document.createElement("option");
      candidateOption.value = candidate;
      candidateOption.innerText = candidateName;
      candidateOptions.appendChild(candidateOption);
    });
  }

  populateCandidates();
})();
