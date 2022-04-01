<template>
  <!-- Navigation-->
  <nav
    class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top"
    id="sideNav"
  >
    <nuxt-link class="navbar-brand js-scroll-trigger" to="/#page-top">
      <span class="d-block d-lg-none">EtherKyrie</span>
      <span class="d-none d-lg-block"
        ><img
          class="img-fluid img-profile rounded-circle mx-auto mb-2"
          src="@/assets/img/money.png"
          alt="..."
      /></span>
    </nuxt-link>
    <button
      class="navbar-toggler"
      type="button"
      data-bs-toggle="collapse"
      data-bs-target="#navbarResponsive"
      aria-controls="navbarResponsive"
      aria-expanded="false"
      aria-label="Toggle navigation"
    >
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarResponsive">
      <ul class="navbar-nav">
        <li class="nav-item">
          <nuxt-link to="/#Game" class="nav-link js-scroll-trigger"
            >Game</nuxt-link
          >
        </li>
        <li class="nav-item">
          <nuxt-link to="/#about" class="nav-link js-scroll-trigger"
            >About</nuxt-link
          >
        </li>
      </ul>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'NavMain',
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
