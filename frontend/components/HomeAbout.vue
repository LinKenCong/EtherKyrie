<template>
  <!-- About-->
  <section class="resume-section" id="about">
    <div class="resume-section-content">
      <h2 class="mb-0">
        Is
        <span class="text-primary">KenCong</span>
        Lin
      </h2>
      <div class="subheading mb-5">
        My e-mail is
        <a href="mailto:linkencong@foxmail.com">linkencong@foxmail.com</a>
      </div>
      <p class="lead mb-5">
        My DAPP project, use ERC1155 TOKEN to trade and play games.
      </p>
      <p class="lead mb-5">
        GITHUB:<a class="text-primary mx-3" href="https://github.com/LinKenCong/EtherKyrie">EtherKyrie</a>
      </p>
    </div>
  </section>
</template>

<script>
export default {
  name: 'HomeAbout',
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
