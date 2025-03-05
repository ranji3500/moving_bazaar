import inflection

def to_camel_case(s):
    return inflection.camelize(s, False)

# Example usage
print(to_camel_case("helloWorld"))       # helloWorld
print(to_camel_case("convert_this_text")) # convertThisText
print(to_camel_case("Make-thisCamelCase")) # makeThisCamelCase
