import React, { useState } from "react";
import { tokens_backend } from "../../../declarations/tokens_backend/index";
import { Principal } from "../../../../node_modules/@dfinity/principal/lib/cjs/index";

function Transfer() {

  const [recipientId, setId] = useState("")
  const [amount, setAmount] = useState("")
  const [isDisabled, setDisabled] = useState(false);
  const [feedback, setFeedback] = useState("")
  const [isHidden, setHidden] = useState(true)

  async function handleClick() {
    setHidden(true);
    setDisabled(true);
    const recipient = Principal.fromText(recipientId);
    const amountToTransfer = Number(amount);
    const result = await tokens_backend.transfer(recipient, amountToTransfer);
    setFeedback(result);
    setHidden(false);
    setDisabled(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={recipientId}
                onChange={(e) => setId(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button
           id="btn-transfer" 
           onClick={handleClick}
           disabled = {isDisabled}
           >
            Transfer
          </button>
        </p>
        <p hidden = {isHidden}>
          {feedback}
        </p>
      </div>
    </div>
  );
}

export default Transfer;
