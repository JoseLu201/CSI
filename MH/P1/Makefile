CXX := g++
CXX_FLAGS := -std=c++17 -ggdb

BIN := BIN
SRC := src
INDLUDE := include

LIBRARIES :=
EXECUTABLE := main

all: $(BIN)/$(EXECUTABLE)

run: clean all	
	clear
	./$(BIN)/$(EXECUTABLE)

$(BIN)/$(EXECUTABLE): $(SRC)/*.cpp
	$(CXX) $(CXX_FLAGS) -I$(INDLUDE) $^ -o $@ $(LIBRARIES)

clean:
	rm $(BIN)/*