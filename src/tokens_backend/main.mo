import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Prelude "mo:base/Prelude";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter"; // turn hashmap to array

actor Token {
  var owner : Principal = Principal.fromText("rp5g6-hrpqt-7hlpt-zq6yy-q2hez-7ktqd-6fa54-bnvgh-7zxwj-7pfuv-cae");
  var totalSuply : Nat = 1000000000;
  var symbol : Text = "DISH";

  /*The use of hashmaps is unstable and cannot be sabilized and when chages are deployed it disrupt the
  the variables hence expensive. the use of array is expensive because of treversing while searching or changing the existing data.
  We use the tuples =>(store multiple items in a single variable. Store collection of data).
  Efficient way is to store them in array only when is about to be deployed and returned immediately after.

  */

  private stable var balanceEntries : [(Principal, Nat)] = []; //it is serialized datatype expensive in time and computation.

  private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash); /** <Principal> data type which is key (owner) owns value of Nat amount**/ /**check value given is equal to stored principle then tell hash map how to hash the keys*/
  if (balances.size() < 1) {
    balances.put(owner, totalSuply);
  };

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
  public shared (msg) func payOut() : async Text {
    // Debug.print(debug_show(msg.caller));
    if (balances.get(msg.caller) == null) {
      let amount = 10000;
      let result = await transfer(msg.caller, amount);
      return result;
    } else {
      return "Already Claimed";
    };
  };

  //Transfer amount
  //the thransfer will be from message caller (shared (msg)) to principle(owner to caller).
  //**Whoever triggers the function is going to be the one the money is tacken from.
  public shared (msg) func transfer(to : Principal, amount : Nat) : async Text {
    let fromBalance = await balanceOf(msg.caller);
    if (fromBalance > amount) {
      let newFromBalance : Nat = fromBalance -amount;
      balances.put(msg.caller, newFromBalance);

      let toBalance = await balanceOf(to);
      let newToBalance = toBalance + amount;
      balances.put(to, newToBalance);

      return "success";
    } else {
      return "Insurficient Funds";
    };
  };

  system func preupgrade() {
    balanceEntries := Iter.toArray(balances.entries()); //ballance is not iteratable
  };
  system func postupgrade() {
    balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
    if (balances.size() < 1) {
      balances.put(owner, totalSuply);
    };
  };

};
