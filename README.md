# Test

Small mining script

It mines one coin by default, and regularly checks difficulty of an alternate coin.

When diff is under a min_value, script switches to mine alt_coin.

While mining alt_coin, if diff is over a max_value, it switches to default coin.

Leave a gap of 10-20% between min_diff and max_diff to avoid too much switching.

Coins, miners, pools, diffs and check interval can be modified inside script.

Run with powershell.


For personal use only.
Falacio 2018.

BTC adress: 3LKW1rbeEY6iprYx49hfp8HaHKvgsh5TpU
