<template>
  <div class="wrapper">
    <NavMain />
    <!-- Page Content-->
    <main class="container-fluid p-0">
      <section class="p-3" id="page-top">
        <div class="mb-3">
          <div class="list-group">
            <a
              href="#"
              class="list-group-item list-group-item-action"
              v-for="(item, index) in 5"
              :key="index"
              >Start Game</a
            >
          </div>
        </div>
        <div class="row row-cols-1 row-cols-md-2 g-4 mb-3">
          <div class="col" v-for="(item, index) in 4" :key="index">
            <div class="card">
              <div class="card-body">
                <h5 class="card-title">Card title</h5>
                <p class="card-text">
                  This is a longer card with supporting text below as a natural
                  lead-in to additional content. This content is a little bit
                  longer.
                </p>
              </div>
            </div>
          </div>
        </div>
        <div class="mb-3">
          <div class="card">
            <div class="card-header">Featured</div>
            <div class="card-body">
              <div class="list-group mb-3">
                <a
                  href="#"
                  class="list-group-item list-group-item-action"
                  v-for="(item, index) in 5"
                  :key="index"
                  >Ether: 100 => Address</a
                >
              </div>
              <button
                type="button"
                class="btn btn-primary px-5 py-2"
                @click="clickTest"
              >
                Confirm Vote
              </button>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { connectETH, transferGold } from '../utils/ethersApi'

export default Vue.extend({
  name: 'SpecialChoose',
  methods: {
    async clickTest() {
      const res = await transferGold(
        '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
        5000
      )
      console.log(res)
    },
  },
})
</script>
