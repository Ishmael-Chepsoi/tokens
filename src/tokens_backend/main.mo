import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Prelude "mo:base/Prelude";
import Text "mo:base/Text";
import Debug "mo:base/Debug";

actor Token {
  var owner : Principal = Principal.fromText("rp5g6-hrpqt-7hlpt-zq6yy-q2hez-7ktqd-6fa54-bnvgh-7zxwj-7pfuv-cae");
  var totalSuply : Nat = 1000000000;
  var symbol : Text = "DISH";

  var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash); /** <Principal> data type which is key (owner) owns value of Nat amount**/ /**check value given is equal to stored principle then tell hash map how to hash the keys*/

  balances.put(owner, totalSuply);

  public query func balanceOf(who : Principal) : async Nat {

    let balance : Nat = switch (balances.get(who)) {
      case null 0;
      case (?result) result;
    };
    return balance;
  };

  public query func getSymbol() : async Text {
    return symbol;
  };
  public shared(msg) func payOut(): async Text{
    // Debug.print(debug_show(msg.caller));
    if (balances.get(msg.caller) == null) {
    let amount = 10000;
    balances.put(msg.caller, amount);
    return "Success";
    }else {
      return "Already Claimed"
    }

  }
};
