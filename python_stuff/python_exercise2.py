import random

gamma = 0.95
altha = 0.1

epsilon_value = 0

def move_and_give_reward(dir,stateR,stateC,max_row,max_column,world):
    """
    # Arguments:
    #   dir (int): The direction to move. 
    #       0 = right, 1 = left, 2 = up, 3 = down.
    #   stateR (int): The current row index of the agent.
    #   stateC (int): The current column index of the agent.
    #
    # Returns:
    #   tuple: (new_row, new_column, reward_value, stop_code)
    #       new_row (int): The new row index after moving.
    #       new_column (int): The new column index after moving.
    #       reward_value (float): The reward received for the move
    #       stop_code (int): An indicator of the state type, where:
    #           1 = keep going, 2 = lose, 3 = win.

    """
    row = stateR
    column = stateC
    reward = "w"
    #0 = right
    #1 = left
    #2 = up
    #3 = down

    if dir == 0:
        if stateC != max_column:
            column += 1
            reward = world[row][column]
    
    elif dir == 1:
        if stateC != 0:
            column -= 1
            reward = world[row][column]

    elif dir == 2:
        if stateR != 0:
            row -= 1
            reward = world[row][column]
    
    elif dir == 3:
        if stateR != max_row: 
            row += 1
            reward = world[row][column]
    

    if reward == "o":
        return (row,column,-1,1)
    elif reward == "h":
        return (row,column,-100,2)
    elif reward == "g":
        return (row,column,10000,3)
    elif reward == "s":
        return (row,column,-5,1)
    elif reward == "w":
        return (row,column,-100,1)

def episode(row,col,q_table,max_column,max_row,world):

    stop = 1
    while stop == 1:
        b = -9999999999999999999
        index = 0
        state = get_state(row, col,max_column)
        # replace this with a greedy policy
        if random.random() < epsilon_value:
            action = random.choice([0,1,2,3])
        else:
            for x in range(len(q_table[state])):
                if q_table[state][x] > b:
                    b = q_table[state][x]
                    index = x
            #give best action
            action = index
        # -----------------------------
        row, col, reward, stop = move_and_give_reward(action,row,col,max_row,max_column,world)
        new_movements = q_table[get_state(row, col,max_column)]
        TD = (reward + max(new_movements)) - q_table[state][action]
        q_table[state][action] = q_table[state][action] + (altha * TD)

def get_state(row, col, max_column):
    return row*(max_column+1) + col

def create_world():
    #ai starts in the top-left corner
    return[["o","o","o","o","o","o","h","o"],
           ["o","o","o","o","o","h","g","h"],
           ["o","o","o","o","o","o","h","o"],
           ["o","o","o","o","o","o","o","o"],
           ["o","o","o","o","o","h","o","o"],
           ["o","o","o","o","h","g","h","g"]]

def train(max_column,max_row,world):
    q_table = []
    for x in world:
        for y in x:
            q_table.append([0,0,0,0])
    for x in range(100000):
        episode(0,0,q_table,max_column,max_row,world)
    return q_table

def main():
    world = create_world()

    max_row = len(world) - 1
    max_column = len(world[0]) - 1
    
    q_table = train(max_column,max_row,world)

    run(q_table,max_row,max_column,world)

def run(q_table,max_row,max_column,world):
    stop = 1
    row = 0
    col = 0
    count = 0
    while stop == 1 and count != max_row*max_column + 1:
        state = get_state(row, col, max_column)
        b = -999999999999999999
        index = 0
        
        for x in range(len(q_table[state])):
            if q_table[state][x] > b:
                b = q_table[state][x]
                index = x
        if index == 0:
            print("right")
        elif index == 1:
            print("left")
        elif index == 2:
            print("up")
        elif index == 3:
            print("down")
        else:
            print("NotADir")


        row,col,reward,stop = move_and_give_reward(index,row,col,max_row,max_column,world)
        count += 1



    if stop == 2:
        print("you died") 
    elif stop == 3:
        print("you win")
    else:
        print("you suck")

main()