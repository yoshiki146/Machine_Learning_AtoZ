# Upper Confidence Bound 

dataset = read.csv('Ads_CTR_Optimisation.csv')

#### random selection ####
N= 10000
d=10
ads_selected=c()
total_reward=0

for (n in 1:N){
  ad=sample(1:d,1)
  ads_selected[n]= ad
  reward=dataset[n,ad]
  total_reward=total_reward+ reward
}

hist(ads_selected, col='blue')

#### UCB ####
N=10000
d=10
ads_selected=c()
numbers_of_selections=c(rep(0,10))  # The number of times each ad is shown
sums_of_rewards=c(rep(0,10))
total_reward=0

for (n in 1:N){
  ad=0
  max_upper_bound=0   # upper bound changes (moves up or down) each time the ad is selected, hence reset MUB each round n.
  for (i in 1:d){
    if (numbers_of_selections[i]>0){
      aveReward= sums_of_rewards[i]/numbers_of_selections[i]
      delta_i=sqrt(3/2 * log(n)/numbers_of_selections[i])
      upper_bound= aveReward+delta_i
    } else {upper_bound=1e400}  # else condition for first d rounds
    if (upper_bound>max_upper_bound){
      max_upper_bound= upper_bound
      ad=i
    }
  }
  ads_selected[n] = ad
  numbers_of_selections[ad] = numbers_of_selections[ad]+1
  reward=dataset[n,ad]
  sums_of_rewards[ad]=sums_of_rewards[ad]+reward
  total_reward= total_reward+reward
}

hist(ads_selected, col='blue')