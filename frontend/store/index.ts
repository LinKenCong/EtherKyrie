export default {
    state: () => ({
        counter: 0,
        account: '',
    }),
    mutations: {
        increment(state: any) {
            state.counter++
        },
        setAccount(state: any, value: string) {
            state.account = value
        }
    },
    actions: {
    }

}