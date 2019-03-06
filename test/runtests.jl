using Test
using StaticArrays
using RootedTrees

t1 = RootedTree([1,2,3])
t2 = RootedTree([1,2,3])
t3 = RootedTree([1,2,2])
t4 = RootedTree([1,2,3,3])

@test t1 == t1
@test t1 == t2
@test !(t1 == t3)
@test !(t1 == t4)

@test t3 < t2    && t2 > t3
@test !(t2 < t3) && !(t3 > t2)
@test t1 < t4    && t4 > t1
@test !(t4 < t1) && !(t1 > t4)
@test t1 <= t2   && t2 >= t1
@test t2 <= t2   && t2 >= t2

t = RootedTree([1])
@test order(t) == 1
@test σ(t) == 1
@test γ(t) == 1
@test α(t) == 1

t = RootedTree([1, 2])
@test order(t) == 2
@test σ(t) == 1
@test γ(t) == 2
@test α(t) == 1

t = RootedTree([1, 2, 2])
@test order(t) == 3
@test σ(t) == 2
@test γ(t) == 3
@test α(t) == 1

t = RootedTree([1, 2, 3])
@test order(t) == 3
@test σ(t) == 1
@test γ(t) == 6
@test α(t) == 1

t = RootedTree([1, 2, 2, 2])
@test order(t) == 4
@test σ(t) == 6
@test γ(t) == 4
@test α(t) == 1

t = RootedTree([1, 2, 2, 3])
@test order(t) == 4
@test σ(t) == 1
@test γ(t) == 8
@test α(t) == 3

t = RootedTree([1, 2, 3, 3])
@test order(t)    == 4
@test σ(t) == 2
@test γ(t)  == 12

t = RootedTree([1, 2, 3, 4])
@test order(t) == 4
@test σ(t) == 1
@test γ(t) == 24
@test α(t) == 1

t = RootedTree([1, 2, 2, 2, 2])
@test order(t) == 5
@test σ(t) == 24
@test γ(t) == 5
@test α(t) == 1

t = RootedTree([1, 2, 2, 2, 3])
@test order(t) == 5
@test σ(t) == 2
@test γ(t) == 10
@test α(t) == 6

t = RootedTree([1, 2, 2, 3, 3])
@test order(t) == 5
@test σ(t) == 2
@test γ(t) == 15
@test α(t) == 4

t = RootedTree([1, 2, 2, 3, 4])
@test order(t) == 5
@test σ(t) == 1
@test γ(t) == 30
@test α(t) == 4

t = RootedTree([1, 2, 3, 2, 3])
@test order(t) == 5
@test σ(t) == 2
@test γ(t) == 20
@test α(t) == 3

t = RootedTree([1, 2, 3, 3, 3])
@test order(t) == 5
@test σ(t) == 6
@test γ(t) == 20
@test α(t) == 1

t = RootedTree([1, 2, 3, 3, 4])
@test order(t) == 5
@test σ(t) == 1
@test γ(t) == 40
@test α(t) == 3

t = RootedTree([1, 2, 3, 4, 4])
@test order(t) == 5
@test σ(t) == 2
@test γ(t) == 60
@test α(t) == 1

t = RootedTree([1, 2, 3, 4, 5])
@test order(t) == 5
@test σ(t) == 1
@test γ(t) == 120
@test α(t) == 1

# see butcher2008numerical, Table 302(I)
number_of_rooted_trees = [1, 1, 2, 4, 9, 20, 48, 115, 286, 719]
for order in 1:10
  num = 0
  for t in RootedTreeIterator(order)
    num += 1
  end
  @test num == number_of_rooted_trees[order] == count_trees(order)
end

# Runge-Kutta method SSPRK33
A = [0 0 0; 1 0 0; 1/4 1/4 0]
b = [1/6, 1/6, 2/3]
c = A * fill(1, length(b))
for order in 1:3
  for t in RootedTreeIterator(order)
    @test residual_order_condition(t, A, b, c) ≈ 0 atol=eps()
  end
end

A = @SArray [0 0 0; 1 0 0; 1/4 1/4 0]
b = @SArray [1/6, 1/6, 2/3]
c = A * SVector(1, 1, 1)
for order in 1:3
  for t in RootedTreeIterator(order)
    @test residual_order_condition(t, A, b, c) ≈ 0 atol=eps()
  end
end
