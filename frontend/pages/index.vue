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
            <button type="button" class="btn btn-primary px-5 py-2">Connect MetaMask</button>
          </div>
        </div>
      </section>
      <hr class="m-0" />
      <HomeGame />
      <hr class="m-0" />
      <HomeAbout />
    </main>
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-Nj1D6pu2WnJojj+67GiU9ZFNwbl7bUWX5Kj5MS22C8bGjllemM9pvQyvj14zJb58"
      crossorigin="anonymous"
    ></script>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

export default Vue.extend({
  name: 'IndexPage',
})
</script>
