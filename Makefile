CXX=g++
LIBS=-pthread -lcryptopp -lboost_system -lboost_filesystem -lboost_timer -lboost_chrono
CXXFLAGS=-std=c++17 $(LIBS)
CXX_DEBUGFLAGS=-g

SRC_DIR=src
TEST_DIR=test
BUILD_DIR=build

SERVER_DIR=$(SRC_DIR)/server
CLIENT_DIR=$(SRC_DIR)/client

CRYPTOGRAPHY_DIR=$(SRC_DIR)/cryptography
NETWORK_DIR=$(SRC_DIR)/network
SHELL_DIR=$(SRC_DIR)/shell

SERVER_TARGET=server
CLIENT_TARGET=client

MUTUAL_HEADERS=$(CRYPTOGRAPHY_DIR)/cryptography.h $(NETWORK_DIR)/session.h
MUTUAL_DEPENDENCIES=$(CRYPTOGRAPHY_DIR)/cryptography.cpp $(NETWORK_DIR)/session.cpp

SERVER_HEADERS=$(SERVER_DIR)/serversession.h $(SHELL_DIR)/shell.h
SERVER_DEPENDENCIES=$(SERVER_DIR)/serversession.cpp $(SHELL_DIR)/shell.cpp
SERVER=$(SERVER_DIR)/server.cpp

CLIENT_HEADERS=$(CLIENT_DIR)/clientsession.h
CLIENT_DEPENDENCIES=$(CLIENT_DIR)/clientsession.cpp
CLIENT=$(CLIENT_DIR)/client.cpp

TEST_CRYPTO=test_cryptography
TEST_SHELL=test_shell

TEST_LOG_LEVEL=-l test_suite

GEN_DH=generate_dh

all: $(SERVER_TARGET) $(CLIENT_TARGET)

debug: CXXFLAGS += -g -DDEBUG=1
debug: all

test: test_crypto test_shell

$(SERVER_TARGET): $(SERVER) $(MUTUAL_HEADERS) $(MUTUAL_DEPENDENCIES) $(SERVER_HEADERS) $(SERVER_DEPENDENCIES)
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/$(SERVER_TARGET) $(SERVER) $(MUTUAL_DEPENDENCIES) $(SERVER_DEPENDENCIES)

$(CLIENT_TARGET): $(CLIENT) $(MUTUAL_HEADERS) $(MUTUAL_DEPENDENCIES) $(CLIENT_HEADERS) $(CLIENT_DEPENDENCIES)
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/$(CLIENT_TARGET) $(CLIENT) $(MUTUAL_DEPENDENCIES) $(CLIENT_DEPENDENCIES)

test_crypto: $(TEST_DIR)/$(TEST_CRYPTO).cpp $(CRYPTOGRAPHY_DIR)/cryptography.cpp
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/$(TEST_CRYPTO) $(CRYPTOGRAPHY_DIR)/cryptography.cpp $(TEST_DIR)/$(TEST_CRYPTO).cpp
	@eval $(BUILD_DIR)/$(TEST_CRYPTO) $(TEST_LOG_LEVEL)
	$(RM) $(BUILD_DIR)/$(TEST_CRYPTO)

test_shell: $(TEST_DIR)/$(TEST_SHELL).cpp $(SHELL_DIR)/shell.cpp
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/$(TEST_SHELL) $(SHELL_DIR)/shell.cpp $(TEST_DIR)/$(TEST_SHELL).cpp
	@eval $(BUILD_DIR)/$(TEST_SHELL) $(TEST_LOG_LEVEL)
	$(RM) $(BUILD_DIR)/$(TEST_SHELL)

clean:
	$(RM) $(BUILD_DIR)/*