import random


world = [["o","o","o","o","o","o"],
         ["h","h","h","o","h","o"],
         ["g","o","h","o","h","o"],
         ["h","o","h","h","h","o"],
         ["o","o","o","o","o","o"]]

gamma = 0.95
altha = 0.1
max_row = len(world) - 1
max_column = len(world[0]) - 1
epsilon_value = 0.1

def move_and_give_reward(dir,stateR,stateC):
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
        return (row,column,-1,False)
    elif reward == "h":
        return (row,column,-100,True)
    elif reward == "g":
        return (row,column,20,True)
    elif reward == "w":
        return (row,column,-100,False)



def episode(row,col,q_table):

    stop = False
    while not stop:
        b = -9999999999999999999
        index = 0
        state = get_state(row, col)
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
        row, col, reward, stop = move_and_give_reward(action,row,col)
        new_movements = q_table[get_state(row, col)]
        TD = (reward + max(new_movements)) - q_table[state][action]
        q_table[state][action] = q_table[state][action] + (altha * TD)

def get_state(row, col):
    return row*(max_column+1) + col

def main():
    q_table = []
    for x in world:
        for y in x:
            q_table.append([0,0,0,0])
    for x in range(1000):
        episode(0,0,q_table)

    count = 1
    for x in q_table:
        print(str(count) + ":" + str(x))
        count+=1

    run(q_table)

def run(q_table):
    row = 0
    col = 0
    count = 0
    while world[row][col] != 'g' and world[row][col] != 'h' and count != ((max_column*max_row) + 1):
        state = get_state(row, col)
        b = -999999999999999999
        index = 0
        
        for x in range(len(q_table[state])):
            if q_table[state][x] > b:
                b = q_table[state][x]
                index = x

        print(q_table[state][index])
        if index == 0:
            print("right")
            col += 1
        elif index == 1:
            print("left")
            col -= 1
        elif index == 2:
            print("up")
            row -= 1
        elif index == 3:
            print("down")
            row += 1
        count += 1
        

main()