fn main() {
    let from = 372_304;
    let to = 847_060;

    let result = (from..to)
        .map(|n| n.to_string().chars().collect::<Vec<char>>())
        .filter(|digits| all_increasing_digits(digits) && has_pair_of_digits(digits))
        .count();

    println!("{}", result);
}

fn all_increasing_digits(number: &Vec<char>) -> bool {
    number.windows(2).all(|digits| digits[0] <= digits[1])
}

fn has_pair_of_digits(number: &Vec<char>) -> bool {
    number.windows(2).any(|digits| digits[0] == digits[1])
}
