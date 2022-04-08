<template>
  <div class="wrapper">
    <NavMain />
    <!-- Page Content-->
    <main class="container-fluid p-0">
      <section class="resume-section" v-if="account">
        <div class="resume-section-content">
          <div class="row row-cols-1 row-cols-md-2 g-4 mb-3">
            <div
              class="col"
              v-for="(item, index) in 4"
              :key="index"
              @click="userChoose(index)"
            >
              <div class="card">
                <div
                  :class="[
                    choose == index ? 'btn-success card-body' : 'card-body',
                  ]"
                >
                  <h3 class="card-title text-center">{{ index + 1 }}</h3>
                </div>
              </div>
            </div>
          </div>
          <div class="mb-3">
            <div class="card">
              <div class="card-header">SpecialChoose Console</div>
              <div class="card-body">
                <button
                  type="button"
                  class="btn btn-info px-5 py-2"
                  @click="newGame"
                >
                  1.New Game
                </button>
                <button
                  type="button"
                  class="btn btn-warning px-5 py-2"
                  @click="startGame"
                >
                  2.Start Game
                </button>
                <button
                  type="button"
                  class="btn btn-danger px-5 py-2"
                  @click="endGame"
                >
                  4.End Game
                </button>
                <button
                  type="button"
                  class="btn btn-success px-5 py-2"
                  @click="getFaucet"
                >
                  Gold Faucet
                </button>
              </div>
            </div>
          </div>
          <div class="mb-3">
            <div class="card">
              <div class="card-header">SpecialChoose Vote</div>
              <div class="card-body">
                <div class="mb-3">
                  <ul class="mb-3">
                    <li>
                      Account: <span class="text-primary">{{ account }}</span>
                    </li>
                    <li>
                      Gold Balance:
                      <span class="text-primary">{{ balance }}</span>
                    </li>
                    <li>
                      Your Choose:
                      <span class="text-primary">{{ choose + 1 }}</span>
                    </li>
                    <li>Will Cost Gold : 10000</li>
                  </ul>
                </div>
                <button
                  type="button"
                  class="btn btn-primary px-5 py-2"
                  @click="voteSubmit"
                >
                  3.Confirm Vote
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>
      <section class="resume-section" v-if="!account">
        <div class="resume-section-content">
          <h1 class="mb-5">
            You need to connect to
            <span class="text-warning">MetaMask</span>
          </h1>
          <button
            type="button"
            class="btn btn-primary px-5 py-2"
            @click="connect"
          >
            Connect MetaMask
          </button>
        </div>
      </section>
    </main>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import {
  connectETH,
  EtherKyrieFaucet,
  SpecialChooseNew,
  SpecialChooseStart,
  SpecialChooseDoVote,
  SpecialChooseEnd,
} from '../utils/ethersApi'

export default Vue.extend({
  name: 'SpecialChoose',
  computed: {
    StoreData() {
      return this.$store.state
    },
  },
  data() {
    return {
      account: '',
      balance: '',
      choose: 0,
    }
  },
  mounted() {
    this.account = this.StoreData.account
    if (this.account) {
      this.connect()
    }
  },
  methods: {
    userChoose(key: number) {
      this.choose = key
    },
    async connect() {
      await connectETH().then((res) => {
        if (res.state == 0) {
          this.account = res.data.account
          this.balance = res.data.balance
          return res.data.balance
        } else {
          alert(res.errmsg)
        }
      })
    },
    async newGame() {
      await SpecialChooseNew().then((res) => {
        if (res.state == 0) {
          console.log(res.data.transactionHash)
        } else {
          alert(res.errmsg)
        }
      })
    },
    async startGame() {
      await SpecialChooseStart().then((res) => {
        if (res.state == 0) {
          console.log(res.data.transactionHash)
        } else {
          alert(res.errmsg)
        }
      })
    },
    async endGame() {
      await SpecialChooseEnd().then((res) => {
        if (res.state == 0) {
          console.log(res.data.transactionHash)
        } else {
          alert(res.errmsg)
        }
      })
      await this.connect()
    },
    async voteSubmit() {
      await SpecialChooseDoVote(this.choose).then((res) => {
        if (res.state == 0) {
          console.log(res.data.transactionHash)
        } else {
          alert(res.errmsg)
        }
      })
      await this.connect()
    },
    async getFaucet() {
      await EtherKyrieFaucet().then((res) => {
        if (res.state == 0) {
          console.log(res.data.transactionHash)
        } else {
          alert(res.errmsg)
        }
      })
      await this.connect()
    },
  },
})
</script>
