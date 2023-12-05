#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>

#define INPUT_FILE "input"

struct Card {
    std::vector<std::vector<int>> numbers;
    int winners;
    int clones;
};

std::vector<int> parse_numbers(std::string numbers_str) {
    std::vector<int> numbers;
    std::stringstream ss(numbers_str);
    int num;
    while (ss >> num) {
        numbers.push_back(num);
    }
    return numbers;
}

Card parse_line(std::string line) {
    std::vector<std::vector<int>> numbers;
    size_t colon_pos = line.find(':');
    size_t pipe_pos = line.find('|', colon_pos + 1);
    numbers.push_back(parse_numbers(line.substr(colon_pos + 1, pipe_pos - colon_pos - 1)));
    numbers.push_back(parse_numbers(line.substr(pipe_pos + 1)));
    return {numbers, 0, 1};
}

std::vector<int> intersect(std::vector<int> v1, std::vector<int> v2) {
    std::sort(v1.begin(), v1.end());
    std::sort(v2.begin(), v2.end());
    std::vector<int> result(v1.size() + v2.size());
    std::vector<int>::iterator it = std::set_intersection(v1.begin(), v1.end(), v2.begin(), v2.end(), result.begin());
    result.resize(it - result.begin());
    return result;
}

std::vector<Card> load_input() {
    std::ifstream input_file(INPUT_FILE);
    std::string line;
    std::vector<Card> result;
    while (std::getline(input_file, line)) {        
        result.push_back(parse_line(line));
    }
    input_file.close();
    return result;
}

int count_score(std::vector<Card>* deck) {
    int grand_total = 0;
    for (int i = 0; i < (*deck).size(); i++) {
        std::vector<int> winners = intersect((*deck)[i].numbers[0], (*deck)[i].numbers[1]);
        (*deck)[i].winners = winners.size();
        unsigned int score = winners.empty() ? 0 : 0b1;
        for (int j = 1; j < (*deck)[i].winners; j++) {
            score <<= 1;
        }
        grand_total = grand_total + score;
    }
    return grand_total;
}

int count_tickets(std::vector<Card> deck) {
    int count = 0;
    for (int i = 0; i < deck.size(); i++) {
        count += deck[i].clones;
        for (int j = 1; j <= deck[i].clones; j++) {
            for (int k = 1; k <= deck[i].winners; k++) {
                deck[i+k].clones++;
            }
        }
    }
    return count;
}

int main() {
    std::vector<Card> deck = load_input();
    int score = count_score(&deck);
    std::cout << "Part 1: " << score << "\n";
    int cards = count_tickets(deck);
    std::cout << "Part 2: " << cards << "\n";
    return 0;
}
