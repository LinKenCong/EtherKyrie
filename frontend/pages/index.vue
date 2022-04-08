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
                  <div class="row g-3 align-items-center mb-2">
                    <div class="input-group mb-2 col-auto">
                      <span class="input-group-text">Address</span>
                      <input
                        type="text"
                        class="form-control"
                        aria-label="transferAccount"
                        v-model="transferAccount"
                      />
                      <span class="input-group-text">Transfer Address</span>
                    </div>
                  </div>
                  <div class="row g-3 align-items-center mb-2">
                    <div class="input-group mb-2 col-auto">
                      <span class="input-group-text">$</span>
                      <input
                        type="text"
                        class="form-control"
                        aria-label="Amount (to the nearest dollar)"
                        v-model="transferAmount"
                      />
                      <span class="input-group-text">Transfer Gold Amount</span>
                    </div>
                  </div>
                  <div class="mb-2" v-if="transferAmount">
                    <p class="mb-1">
                      You Will Transfer {{ transferAmount }} to
                      {{ transferAccount }}
                    </p>
                    <p v-if="transactionHash">
                      TransactionHash:
                      <span class="text-primary">{{ transactionHash }}</span>
                    </p>
                  </div>
                  <button
                    type="button"
                    class="btn btn-primary px-5 py-2 mb-2"
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
import { connectETH, transferGold } from '../utils/ethersApi'

export default Vue.extend({
  name: 'IndexPage',
  computed: {
    StoreData() {
      return this.$store.state
    },
  },
  data() {
    return {
      account: '',
      balance: '',
      transferAccount: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
      transferAmount: 5000,
      transactionHash: '',
    }
  },
  mounted() {
    this.account = this.StoreData.account
     if (this.account) {
      this.connect()
    }
  },
  methods: {
    ...mapMutations({
      setAccount: 'setAccount',
    }),
    async connect() {
      await connectETH().then((res) => {
        if (res.state == 0) {
          this.setAccount(res.data.account)
          this.account = res.data.account
          this.balance = res.data.balance
        } else {
          alert(res.errmsg)
        }
      })
    },
    async transferGold() {
      await transferGold(this.transferAccount, this.transferAmount).then(
        (res) => {
          if (res.state == 0) {
            this.transactionHash = res.data.transactionHash
          } else {
            alert(res.errmsg)
          }
        }
      )
    },
  },
})
</script>
