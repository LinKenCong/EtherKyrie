<template>
  <!-- Game-->
  <section class="resume-section" id="Game">
    <div class="resume-section-content">
      <h2 class="mb-5">Game</h2>
      <div class="subheading mb-5">Choose a game and start earning!!!</div>
      <div class="card mb-3" style="width: 18rem">
        <img src="@/assets/img/money.png" class="card-img-top" alt="..." />
        <div class="card-body">
          <h5 class="card-title">SpecialChoose</h5>
          <p class="card-text">
            Start the game, choose an option that you think no one chooses, the
            option with the least number is the one to win the reward.
          </p>
          <nuxt-link to="/SpecialChoose" class="btn btn-primary">Go SpecialChoose</nuxt-link>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'HomeGame',
  data() {
    return {
      text: 'aa',
    }
  },
  methods: {
    test() {
      this.text = 'vv'
    },
  },
}
</script>
