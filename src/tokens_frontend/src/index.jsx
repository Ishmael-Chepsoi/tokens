import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
import { AuthClient } from '../../../node_modules/@dfinity/auth-client/lib/cjs/index';


const init = async () => { 
  

const authClient = await AuthClient.create();

if (await authClient.isAuthenticated()){
  handleAuthenticated(authClient);
} else {//If not authenticated we force them to log in
  await authClient.login({
    identityProvider: "https://identity.ic0.app/#authorize",
    onSuccess: ()=> {
      ReactDOM.render(<App />, document.getElementById("root"));
    }
  });
}


}
async function handleAuthenticated(authClient){
 const identity = await authClient.getIdentity(); //taping to identity to be displayed in the frontend
 const userPrinciplal = identity._principal.toString();//from log if you console log(authClient.getIdentity())
  ReactDOM.render(<App loggedInPrincipal = {userPrinciplal}/>, document.getElementById("root"));
}
init();

