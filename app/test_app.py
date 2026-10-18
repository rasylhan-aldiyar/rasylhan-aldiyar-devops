import unittest

from app import build_message


class BuildMessageTest(unittest.TestCase):
    def test_uses_environment_variables(self):
        env = {
            "STUDENT_NAME": "Aldiyar",
            "STUDENT_SURNAME": "Rasylhan",
            "STUDENT_GROUP": "IT2-2309",
            "STUDENT_ID": "37838",
        }
        message = build_message(env=env, config={"APP_VERSION": "1.0.0"})
        self.assertIn("Name: Aldiyar", message)
        self.assertIn("Surname: Rasylhan", message)
        self.assertIn("Group: IT2-2309", message)
        self.assertIn("Student ID: 37838", message)
        self.assertIn("Application is running successfully!", message)

    def test_missing_variables_show_unknown(self):
        message = build_message(env={}, config={})
        self.assertIn("Name: Unknown", message)


if __name__ == "__main__":
    unittest.main()
