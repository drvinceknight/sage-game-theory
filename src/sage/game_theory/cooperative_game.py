r"""
Co-operative games with N players.

This module implements characteristic function cooperative games.
The main contribution is a class for a characteristic function game that takes a characteristic function (as a dictionary) as an input.
Methods to calculate the Shapley value (a fair way of sharing common resources: https://www.youtube.com/watch?v=aThG4YAFErw) as well as test properties of the game (monotonicity, super additivity) are also included.

AUTHOR::
- James Campbell 06-2014: Original version

- Vince Knight 06-2014


EXAMPLES::
Basic example of how to implement a co-operative game.

::

sage: test_function = {(): 0,
    ....:                  ('1',): 6,
    ....:                  ('2',): 12,
    ....:                  ('3',): 42,
    ....:                  ('1', '2',): 12,
    ....:                  ('1', '3',): 42,
    ....:                  ('2', '3',): 42,
    ....:                  ('1', '2', '3',): 42}
    sage:
    sage: test_game = CooperativeGame(test_function, ['A', 'B', 'C'])
    sage: print test_game.shapley_value()
    [2, 5, 35]

We can also use strings instead of numbers.

::

    sage: letter_function = {(): 0,
    ....:                  ('A',): 6,
    ....:                  ('B',): 12,
    ....:                  ('C',): 42,
    ....:                  ('A', 'B',): 12,
    ....:                  ('A', 'C',): 42,
    ....:                  ('B', 'C',): 42,
    ....:                  ('A', 'B', 'C',): 42}
    sage:
    sage: letter_game = CooperativeGame(test_function, ['A', 'B', 'C'])
    sage: print letter_game.shapley_value()
    [2, 5, 35]
"""

#*****************************************************************************
#       Copyright (C) 2014 James Campbell james.campbell@tanti.org.uk
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#                  http://www.gnu.org/licenses/
#*****************************************************************************
from itertools import permutations


class CooperativeGame():
    def __init__(self, characteristic_function, player_list):
        self.char_fun = characteristic_function
        self.number_players = len(player_list)
        self.player_list = player_list

    def shapley_value(self):
        r"""
        Return the payoff vector for co-operative game.
        """
        payoff_vector = []
        for i in self.player_list:
            player_contribution = self.marginal_contributions(i)
            average = sum(player_contribution) / len(player_contribution)
            payoff_vector.append(average)
        return payoff_vector

    def is_monotone():
        r"""
        Returns True if co-operative game is monotonic.
        """

    def is_superadditive():
        r"""
        Returns True if co-operative game is superadditive.
        """

    def marginal_contributions(self, player):
        contributions = []
        for i in permutations(self.player_list):
            contributions.append(self.marginal_of_pi(player, i))
        return contributions

    def marginal_of_pi(self, player, pi):
        player_and_pred = self.get_predecessors_and_player(player, pi)
        predecessors = [x for x in player_and_pred if x != player]
        if predecessors == None:
            predecessors = ()
        else:
            predecessors = tuple(predecessors)
        player_and_pred = tuple(player_and_pred)
        value = self.char_fun[player_and_pred] - self.char_fun[predecessors]
        return value

    def get_predecessors_and_player(self, player, permutation):
        predecessors = []
        for k in permutation:
            if k == player:
                predecessors.append(k)
                predecessors.sort()
                return predecessors
            else:
                predecessors.append(k)
