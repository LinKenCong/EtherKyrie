<template>
  <div class="wrapper">
    <NavMain />
    <!-- Page Content-->
    <main class="container-fluid p-0">
      <section class="resume-section" id="page-top">
        <div class="resume-section-content">
          <h1 class="mb-0">
            Ether
            <span class="text-primary">Kyrie</span>
          </h1>
          <div class="my-5">
            <button
              type="button"
              class="btn btn-primary px-5 py-2"
              @click="connect"
              v-if="!account"
            >
              Connect MetaMask
            </button>
            <div class="my-5" v-if="account">
              <div class="card">
                <div class="card-body">
                  <p>
                    <span class="text-primary">Account: </span>{{ account }}
                  </p>
                  <p>
                    <span class="text-primary">Gold Balance:</span>
                    {{ balance }}
                  </p>
                </div>
              </div>
              <div class="card my-5">
                <div class="card-body">
                  <div class="row g-3 align-items-center">
                    <div class="col-auto">
                      <label class="col-form-label">Address</label>
                    </div>
                    <div class="col-auto">
                      <input
                        type="text"
                        class="form-control"
                        v-bind="transferAccount"
                      />
                    </div>
                    <div class="col-auto">
                      <span class="form-text"> Transfer Address </span>
                    </div>
                  </div>
                  <div class="row g-3 align-items-center my-1">
                    <div class="col-auto">
                      <label class="col-form-label">Amount</label>
                    </div>
                    <div class="col-auto">
                      <input
                        type="text"
                        class="form-control"
                        v-bind="transferAmount"
                      />
                    </div>
                    <div class="col-auto">
                      <span class="form-text"> Transfer Gold Amount </span>
                    </div>
                  </div>
                  <div class="my-1" v-if="transferAmount">
                    You Will Transfer {{ transferAmount }} to
                    {{ transferAccount }}
                  </div>
                  <button
                    type="button"
                    class="btn btn-primary px-5 py-2 my-3"
                    @click="transferGold"
                  >
                    Transfer
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <hr class="m-0" />
      <HomeGame />
      <hr class="m-0" />
      <HomeAbout />
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { mapMutations } from 'vuex'
import { ethers } from 'ethers'

export default Vue.extend({
  name: 'IndexPage',
  computed: {
    ethersData() {
      return this.$store.state
    },
  },
  data() {
    return {
      account: null,
      balance: null,
      signer: null,
      busd: null,
      transferAccount: null,
      transferAmount: null,
    }
  },
  mounted() {
    this.connect()
  },
  methods: {
    ...mapMutations({
      setAccount: 'setAccount',
      setSigner: 'setSigner',
      setBusd: 'setBusd',
    }),
    async connectETH() {
      const provider: any = new ethers.providers.Web3Provider(
        window.ethereum,
        'any'
      )
      await provider.send('eth_requestAccounts', [])
      const signer: any = provider.getSigner()
      const account: any = await signer.getAddress()
      this.signer = signer
      this.account = account
      // this.setSigner(signer)
      // this.setAccount(account)
    },
    async connectContract() {
      this.signer != null || (await this.connectETH())
      const busd: any = new ethers.Contract(
        '0x5FbDB2315678afecb367f032d93F642f64180aa3',
        [
          'event ApprovalForAll(address indexed,address indexed,bool)',
          'event OwnershipTransferred(address indexed,address indexed)',
          'event TransferBatch(address indexed,address indexed,address indexed,uint256[],uint256[])',
          'event TransferSingle(address indexed,address indexed,address indexed,uint256,uint256)',
          'event URI(string,uint256 indexed)',
          'function GOLD() view returns (uint256)',
          'function addPlayer(string)',
          'function balanceOf(address,uint256) view returns (uint256)',
          'function balanceOfBatch(address[],uint256[]) view returns (uint256[])',
          'function doVote(uint256)',
          'function etherKyrieFaucet()',
          'function gamesNumber() view returns (uint256)',
          'function getPlayerInfo(address) view returns (tuple(address,string,uint8))',
          'function getSCWinChose(uint256) view returns (uint256[])',
          'function getSCWinner(uint256) view returns (address[])',
          'function initializeContract()',
          'function isApprovedForAll(address,address) view returns (bool)',
          'function newSCGame()',
          'function onERC1155BatchReceived(address,address,uint256[],uint256[],bytes) returns (bytes4)',
          'function onERC1155Received(address,address,uint256,uint256,bytes) returns (bytes4)',
          'function owner() view returns (address)',
          'function payWinner()',
          'function playerCount() view returns (uint256)',
          'function players(address) view returns (address, string, uint8)',
          'function playersInGame(uint256) view returns (address, string, uint8)',
          'function renounceOwnership()',
          'function safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)',
          'function safeTransferFrom(address,address,uint256,uint256,bytes)',
          'function setApprovalForAll(address,bool)',
          'function setSCEnd()',
          'function setSCStart()',
          'function supportsInterface(bytes4) view returns (bool)',
          'function transferOwnership(address)',
          'function uri(uint256) view returns (string)',
        ],
        this.signer
      )
      this.busd = busd
      // this.setBusd(busd)
    },
    async getBalance() {
      this.busd != null || (await this.connectContract())
      const balance: any = await this.busd
        .balanceOf(this.account, 0)
        .then((rel: any) => rel.toString())
      this.balance = balance
    },
    async connect() {
      await this.getBalance()
    },
    async transferGold() {
      if (this.transferAccount == '') return
      this.busd != null || (await this.connectContract())
      let tx: any = await this.busd.safeTransferFrom(
        this.account,
        this.transferAccount,
        0,
        this.transferAmount,
        '0x00'
      )
      const r = await tx.wait(1)
      console.log(r)
    },
  },
})
</script>
