def remove_duplicates(sequence):
    notDuplicateList=[]
    for i in sequence:
        if i not in notDuplicateList:
            notDuplicateList.append(i)

    for i in notDuplicateList:
        occurence=sequence.count(i)
        print(f"The number {i} occurs {occurence} times")
    return notDuplicateList

y=[1,5,2,5,6,3,6,3,1,3,5,2,4,5,1,2,4,2,3,4,1,2,3,4,5,1]

x=remove_duplicates(y)

print(f"New list is {x}")