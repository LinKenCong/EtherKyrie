<template>
  <!-- Game-->
  <section class="resume-section" id="Game">
    <div class="resume-section-content">
      <h2 class="mb-5">Game</h2>
      <div class="card mb-5">
        <div class="card-header">Player Info</div>
        <div class="card-body">
          <div class="mb-3" v-if="name">
            <ul class="mb-3">
              <li>
                Account: <span class="text-primary">{{ account }}</span>
              </li>
              <li>
                Player Name:
                <span class="text-primary">{{ name }}</span>
              </li>
              <li>
                Player Level:
                <span class="text-primary">{{ level }}</span>
              </li>
              <li>
                Gold Balance:
                <span class="text-primary">{{ balance }}</span>
              </li>
            </ul>
          </div>
          <div class="mb-3" v-if="!name">
            <div class="row g-3 align-items-center mb-2">
              <div class="input-group mb-2 col-auto">
                <span class="input-group-text">Player Name</span>
                <input
                  type="text"
                  class="form-control"
                  aria-label="Player Name"
                  v-model="inputName"
                />
              </div>
            </div>
            <button
              type="button"
              class="btn btn-primary px-5 py-2"
              @click="registerPlayer"
            >
              Be A Player!
            </button>
          </div>
        </div>
      </div>
      <div class="subheading mb-5">Choose a game and start earning!!!</div>
      <div class="card mb-3" style="width: 18rem">
        <img src="@/assets/img/money.png" class="card-img-top" alt="..." />
        <div class="card-body">
          <h5 class="card-title">SpecialChoose</h5>
          <p class="card-text">
            Start the game, choose an option that you think no one chooses, the
            option with the least number is the one to win the reward.
          </p>
          <nuxt-link to="/SpecialChoose" class="btn btn-primary"
            >Go SpecialChoose</nuxt-link
          >
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import { addGamePlayer, getPlayerInfo, connectETH } from '../utils/ethersApi'
export default {
  name: 'HomeGame',
  data() {
    return {
      account: '',
      name: '',
      balance: '',
      level: '',
      inputName: '',
      MsgText: '',
    }
  },
  mounted() {
    this.getPlayerInfo()
  },
  methods: {
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
    async getPlayerInfo() {
      await this.connect()
      await getPlayerInfo().then((res) => {
        if (res.state == 0) {
          this.name = res.data.PlayerName
          this.level = res.data.PlayerLevel
          return res.data
        } else {
          this.MsgText = res.errmsg
        }
      })
    },
    async registerPlayer() {
      if (!this.inputName) return
      await addGamePlayer(this.inputName).then((res) => {
        if (res.state == 0) {
          console.log(res.data.transactionHash)
        } else {
          alert(res.errmsg)
        }
      })
    },
  },
}
</script>
