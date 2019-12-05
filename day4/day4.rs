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
    number
        .into_iter()
        .enumerate()
        .skip(1)
        .scan((number[0], 1), |(last_digit, count), (i, &digit)| {
            if digit != *last_digit && *count == 2 {
                return Some(true);
            }

            if digit == *last_digit && *count == 1 && i == number.len() - 1 {
                return Some(true);
            }

            if digit == *last_digit {
                *count += 1;
            } else {
                *last_digit = digit;
                *count = 1;
            }

            return Some(false);
        })
        .any(|result| result)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_number_with_pair_of_digits() {
        assert!(has_pair_of_digits(&vec!['1', '2', '3', '3', '4']));
    }

    #[test]
    fn test_number_with_pair_of_digits_at_beginning() {
        assert!(has_pair_of_digits(&vec!['1', '1', '2', '3', '4']));
    }

    #[test]
    fn test_number_with_pair_of_digits_at_end() {
        assert!(has_pair_of_digits(&vec!['1', '2', '3', '4', '4']));
    }

    #[test]
    fn test_number_without_pair_of_digits() {
        assert!(!has_pair_of_digits(&vec!['1', '2', '3', '4', '5']));
    }

    #[test]
    fn test_number_with_more_than_two_consecutive_digits() {
        assert!(!has_pair_of_digits(&vec!['1', '2', '2', '2', '3']));
    }
}
