
A Ruby on Rails API demonstrating Role-Based Access Control (RBAC) using a clean Policy-based authorization architecture.

## Tech Stack

- Ruby on Rails (API mode)
- SQLite3
- JSON-only API
- Custom Policy Authorization Layer

---

## Setup Instructions

1️⃣ Clone the repository

```
git clone <your-repository-link>
cd project_collab_api
```

2️⃣ Install dependencies

```
bundle install
```

3️⃣ Setup database

```
rails db:create
rails db:migrate
rails db:seed
```

4️⃣ Start the server

```
rails s
```

Server runs at:

```
http://localhost:3000
```

---

##  Authentication (Mocked)

Authentication is mocked for simplicity.

To simulate different users, pass a request header:

```
USER_ID: <user_id>
```

Example:

```
USER_ID: 1  → Admin
USER_ID: 2  → Manager
USER_ID: 3  → Member
```

If USER_ID is missing or invalid, API returns:

```
401 Unauthorized
```

---

##  Models

### User
- name (string)
- email (string)
- role (admin, manager, member)

### Project
- title (string)
- description (text)
- owner_id (User reference)

### ProjectMembership
- user_id
- project_id
- role (viewer, editor)

---

## Associations

- User has_many owned_projects
- Project belongs_to owner (User)
- Project has_many project_memberships
- Project has_many users through project_memberships

---

## Authorization Approach

Authorization logic is implemented using a separate Policy class:

```
ProjectPolicy
```

Controllers do not contain authorization logic directly.

Instead, they call:

```
policy.create?
policy.update?
policy.destroy?
policy.manage_members?
```

This ensures:

- Clean controller structure
- Separation of concerns
- Reusable authorization logic
- Maintainable and scalable design

---

##  RBAC Rules

### Admin
- Full access to all projects
- Can create, update, delete any project
- Can manage project members

### Manager (Project Owner)
- Can update/delete owned projects
- Can add/remove members from owned projects
- Can assign membership roles

### Member

Viewer:
- Read-only access to assigned projects

Editor:
- Can update assigned projects
- Cannot delete projects

Unauthorized actions return:

```
403 Forbidden
```

---

## API Endpoints

### Project APIs

| Method | Endpoint | Description |
|--------|----------|------------|
| POST | /projects | Create project |
| GET | /projects | List projects |
| GET | /projects/:id | Show project |
| PUT | /projects/:id | Update project |
| DELETE | /projects/:id | Delete project |

---

### Membership APIs

| Method | Endpoint | Description |
|--------|----------|------------|
| POST | /projects/:id/members | Add member |
| DELETE | /projects/:id/members/:user_id | Remove member |

---

## Testing Using curl

Get projects as Admin:

```
curl -H "USER_ID: 1" http://localhost:3000/projects
```

Update project as Member (should return 403):

```
curl -X PUT http://localhost:3000/projects/1 \
-H "Content-Type: application/json" \
-H "USER_ID: 3" \
-d '{"project":{"title":"Updated"}}'
```

Delete project as Admin:

```
curl -X DELETE http://localhost:3000/projects/1 \
-H "USER_ID: 1"
```

---

## Seed Data

Seed file creates:

- 1 Admin
- 1 Manager
- 1 Member
- 1 Sample Project
- Sample Membership

Run:

```
rails db:seed
```

---

## Architecture Highlights

- Policy-based RBAC enforcement
- Clean separation of concerns
- RESTful API design
- Proper HTTP status codes (401, 403, 422, 204)
- SQLite database
- Mock authentication for testing

---

## Assumptions

- Authentication is mocked
- No frontend required
- JSON responses only
- SQLite used for simplicity

---

Sudharsan

