from locust import HttpUser, task, between
import random
import string

class UserGeneration:
    @staticmethod
    def generate_random_user():
        username = ''.join(random.choices(string.ascii_lowercase, k=5))
        email = username + "@example.com"
        return {
            "username": username,
            "email": email
        }

class MyUser(HttpUser):
    wait_time = between(1, 2)

    @task
    def create_user(self):
        user = UserGeneration.generate_random_user()
        self.client.post("/users", json=user)

    @task
    def get_users(self):
        self.client.get("/fibo/2")