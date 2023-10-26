import React, { useState } from "react";
import { Principal } from "../../../../node_modules/@dfinity/principal/lib/cjs/index";
import { tokens_backend } from "../../../declarations/tokens_backend";


// import { Token } from "../../../../node_modules/typescript/lib/typescript";

function Balance() {

  const [inpuValue, setInput] = useState("");
  const [balanceResult, setBalance] = useState("")
  const [cryptoSymbol, setSymbol] = useState("")
  const [isHidden, setHidden] = useState(true)
  

  async function handleClick() {
    // console.log(inpuValue);
    const principal = Principal.fromText(inpuValue);
    const balance = await tokens_backend.balanceOf(principal);
    setBalance(balance.toLocaleString());
    setSymbol(await tokens_backend.getSymbol());
    setHidden(false)

 
  }


  return (
    <div className="window white">
      <label>Check account token balance:</label>
      <p>
        <input
          id="balance-principal-id"
          type="text"
          placeholder="Enter a Principal ID"
          value={inpuValue}
          onChange={(e) => setInput(e.target.value)}
        />
      </p>
      <p className="trade-buttons">
        <button
          id="btn-request-balance"
          onClick={handleClick}
        >
          Check Balance
        </button>
      </p>
      <p hidden = {isHidden}>This account has a balance of {balanceResult}{cryptoSymbol}.</p>
    </div>
  );
}

export default Balance;
