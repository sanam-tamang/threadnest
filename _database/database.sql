

CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    name TEXT NULL,
    image_url VARCHAR NULL,
    bio VARCHAR NULL,
    email VARCHAR NOT NULL
);



-- Table: communities
CREATE TABLE communities (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

-- Table: user_communities
CREATE TABLE user_communities (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    community_id UUID NOT NULL REFERENCES communities(id) ON DELETE CASCADE
);

-- Table: posts
CREATE TABLE posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    community_id UUID NOT NULL REFERENCES communities(id) ON DELETE CASCADE
);

-- Table: post_votes
CREATE TABLE post_votes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

-- Table: post_comments
CREATE TABLE post_comments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    commented_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

-- Table: post_comment_votes
CREATE TABLE post_comment_votes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    comment_id UUID NOT NULL REFERENCES post_comments(id) ON DELETE CASCADE,
    voted_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

-- Table: removed_posts
CREATE TABLE removed_posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    removed_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    community_id UUID NOT NULL REFERENCES communities(id) ON DELETE CASCADE
);

-- Table: rooms
CREATE TABLE rooms (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id1 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_id2 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

-- Table: messages
CREATE TABLE messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

