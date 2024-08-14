import Image from "next/image";
import styles from "./page.module.css";
import App from "@/component/app";
import { Web3Provider } from "../../Web3Provider";

export default function Home() {
  return (
    <Web3Provider>
      <App />
    </Web3Provider>
  );
}
