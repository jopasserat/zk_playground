App = {
  web3Provider: null,
  contracts: {},
  proof: {},

  init: function() {

    return App.initWeb3();
  },

  initWeb3: function() {

    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {

    $.getJSON('Verifier.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var VerifierArtifact = data;
      App.contracts.Verifier = TruffleContract(VerifierArtifact);

      // Set the provider for our contract
      App.contracts.Verifier.setProvider(App.web3Provider);

    });
    return App.bindEvents();
  },


  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.verifyProof);
  },

  // adapted from https://stackoverflow.com/a/36198572/470341
  loadProof: function() {
    var files = document.getElementById('selectFiles').files;
    if (files.length <= 0) {
      return false;
    }

    var fr = new FileReader();

    fr.onload = function(e) {
      App.proof = JSON.parse(e.target.result);
      console.log(App.proof);
    }

    fr.readAsText(files.item(0));
  },

  verifyProof: function() {

    proof = App.loadProof();

    var b1 = $("#b1").val();
    var b2 = $("#b2").val();
    var r1 = $("#r1").val();
    var r2 = $("#r2").val();
    console.log("Input Vector <" + b1 + ", " + b2 + ">");
    console.log("Output Vector <" + r1 + ", " + r2 + ">");

    var verifierInstance;

    inputsOutputs = [b1, b2, r1, r2];

    App.contracts.Verifier.deployed().then(function(instance) {
      verifierInstance = instance;
      // Use our contract to verify proof
      return verifierInstance.verifyTx.call(App.proof.A, App.proof.A_p, App.proof.B, App.proof.B_p, App.proof.C, App.proof.C_p, App.proof.H, App.proof.K, inputsOutputs);
    }).then(function(result) {
      if (result) colorLog("Proof verified!", "success");
      else colorLog("Proof did not verify", "error");
    }).catch(function(err) {
      console.error(err.message);
    });

  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});

// https://stackoverflow.com/a/42551926/470341
function colorLog(message, color) {

    color = color || "black";

    switch (color) {
        case "success":
             color = "Green";
             break;
        case "info":
                color = "DodgerBlue";
             break;
        case "error":
             color = "Red";
             break;
        case "warning":
             color = "Orange";
             break;
        default:
             color = color;
    }

    console.log("%c" + message, "color:" + color);
};

