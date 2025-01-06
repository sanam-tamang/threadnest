-- Function: add_owner_to_community
CREATE OR REPLACE FUNCTION add_owner_to_community(user_id text, community_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    -- Insert the user and community information into the user_communities table
    INSERT INTO user_communities (user_id, community_id)
    VALUES (user_id, community_id)
    ON CONFLICT DO NOTHING; -- Prevent duplicate entries
END;
$$;

-- Function: after_community_created
CREATE OR REPLACE FUNCTION after_community_created()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    -- Call the add_owner_to_community function to add the owner to the community
    PERFORM add_owner_to_community(NEW.owner_id, NEW.id);
    RETURN NEW;
END;
$$;

-- Function: fetch_chat_partners
CREATE OR REPLACE FUNCTION fetch_chat_partners(chat_partner json, id uuid, current_user_id text, is_last_message_read boolean, last_message text, last_message_time timestamp without time zone)
RETURNS SETOF record LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        json_build_object(
            'id', CASE
                WHEN r.user_id1 = current_user_id THEN r.user_id2
                ELSE r.user_id1
            END,
            'name', u.name,
            'email', u.email,
            'image_url', u.image_url,
            'bio', u.bio
        ) AS chat_partner,
        m.content AS last_message,
        m.is_read AS is_last_message_read,
        m.sent_time AS last_message_time
    FROM rooms r
    JOIN users u ON u.id = CASE
        WHEN r.user_id1 = current_user_id THEN r.user_id2
        ELSE r.user_id1
    END
    LEFT JOIN LATERAL (
        SELECT m.content, m.is_read, m.sent_time
        FROM messages as m
        WHERE m.room_id = r.id
        ORDER BY m.sent_time DESC
        LIMIT 1
    ) m ON true
    WHERE r.user_id1 = current_user_id OR r.user_id2 = current_user_id
    ORDER BY r.created_at DESC;
END;
$$;

-- Function: get_currently_visited_user_profile_with_posts
CREATE OR REPLACE FUNCTION get_currently_visited_user_profile_with_posts(currently_visited_profile_id text, current_user_id text)
RETURNS jsonb LANGUAGE plpgsql AS $$
DECLARE
    visited_user_info jsonb;
    posts_info jsonb;
BEGIN
    -- Get the currently visited user's details
    SELECT jsonb_build_object(
        'id', u.id,
        'name', u.name,
        'image_url', u.image_url,
        'bio', u.bio
    ) INTO visited_user_info
    FROM users u
    WHERE u.id = currently_visited_profile_id;

    -- Get the posts made by the currently visited user
    SELECT jsonb_agg(
        jsonb_build_object(
            'id', p.id,
            'title', p.title,
            'content', p.content::text,
            'image_url', p.image_url::text,
            'document_url', p.document_url::text,
            'total_upvotes', COUNT(CASE WHEN pv.vote_type = 'up' THEN 1 END),
            'total_downvotes', COUNT(CASE WHEN pv.vote_type = 'down' THEN 1 END),
            'total_comments', COUNT(DISTINCT pc.id),
            'total_share_count', p.total_share_count
        )
    ) INTO posts_info
    FROM posts p
    LEFT JOIN post_votes pv ON p.id = pv.post_id
    LEFT JOIN post_comments pc ON p.id = pc.post_id
    WHERE p.user_id = currently_visited_profile_id
    GROUP BY p.id;

    -- Return the combined result
    RETURN jsonb_build_object(
        'currentlyVisitedUser', visited_user_info,
        'posts', COALESCE(posts_info, '[]'::jsonb)
    );
END;
$$;

-- Function: get_or_create_chat_room
CREATE OR REPLACE FUNCTION get_or_create_chat_room(chat_partner_id text, current_user_id text)
RETURNS SETOF record LANGUAGE plpgsql AS $$
DECLARE
    existing_room_id UUID;
BEGIN
    -- Check if a room already exists between the current user and the chat partner
    SELECT id INTO existing_room_id
    FROM rooms
    WHERE (user_id1 = current_user_id AND user_id2 = chat_partner_id)
       OR (user_id1 = chat_partner_id AND user_id2 = current_user_id)
    LIMIT 1;

    -- If no room exists, create one
    IF existing_room_id IS NULL THEN
        INSERT INTO rooms (user_id1, user_id2, created_at)
        VALUES (current_user_id, chat_partner_id, NOW())
        RETURNING id INTO existing_room_id;
    END IF;

    -- Return the chat partner's details, including their ID as partner_id
    RETURN QUERY
    SELECT
        existing_room_id AS room_id,
        chat_partner_id AS partner_id,
        u.name::TEXT AS chat_partner_name,
        u.image_url::TEXT AS chat_partner_image_url,
        u.bio::TEXT AS chat_partner_bio
    FROM users u
    WHERE u.id = chat_partner_id;
END;
$$;

-- Function: get_post_with_comments
CREATE OR REPLACE FUNCTION get_post_with_comments(current_post_id uuid, current_user_id text)
RETURNS jsonb LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    WITH comment_data AS (
        SELECT
            pc.id AS comment_id,
            pc.post_id,
            pc.text AS comment_content,
            json_build_object(
                'id', cu.id,
                'name', cu.name,
                'image_url', cu.image_url
            ) AS comment_author,
            COUNT(DISTINCT CASE WHEN pcv.vote_type = 'up' THEN pcv.id END) AS total_upvotes,
            COUNT(DISTINCT CASE WHEN pcv.vote_type = 'down' THEN pcv.id END) AS total_downvotes,
            MAX(CASE WHEN pcv.voted_by = current_user_id THEN pcv.vote_type ELSE null END) AS user_vote_status
        FROM
            post_comments AS pc
        LEFT JOIN
            users AS cu ON pc.commented_by = cu.id
        LEFT JOIN
            post_comment_votes AS pcv ON pc.id = pcv.comment_id
        WHERE
            pc.post_id = current_post_id
        GROUP BY
            pc.id, pc.post_id, cu.id, cu.name, cu.image_url
    )
    SELECT
        p.id,
        p.title,
        p.content::text,
        p.image_url::text,
        p.document_url::text,
        json_build_object(
            'id', u.id,
            'name', u.name,
            'image_url', u.image_url
        ) AS author,
        json_build_object(
            'id', c.id,
            'name', c.name,
            'description', c.description,
            'image_url', c.image_url,
            'owner_id', c.owner_id,
            'is_member', CASE WHEN uc.user_id IS NOT NULL THEN true ELSE false END
        ) AS community,
        COUNT(DISTINCT CASE WHEN pv.vote_type = 'up' THEN pv.id END)::integer AS total_upvotes,
        COUNT(DISTINCT CASE WHEN pv.vote_type = 'down' THEN pv.id END)::integer AS total_downvotes,
        MAX(CASE WHEN user_vote.vote_type = 'up' THEN 'up' WHEN user_vote.vote_type = 'down' THEN 'down' ELSE null END) AS user_vote_status,
        COUNT(DISTINCT cd.comment_id)::integer AS total_comments,
        COALESCE(jsonb_agg(
            DISTINCT jsonb_build_object(
                'id', cd.comment_id,
                'content', cd.comment_content,
                'comment_author', cd.comment_author,
                'total_upvotes', cd.total_upvotes,
                'total_downvotes', cd.total_downvotes,
                'user_vote_status', cd.user_vote_status
            )
        ) FILTER (WHERE cd.comment_id IS NOT NULL), '[]') AS comments
    FROM
        posts AS p
    LEFT JOIN
        post_votes AS pv ON p.id = pv.post_id
    LEFT JOIN
        post_votes AS user_vote ON p.id = user_vote.post_id AND user_vote.user_id = current_user_id
    LEFT JOIN
        users AS u ON p.user_id = u.id
    LEFT JOIN
        communities AS c ON p.community_id = c.id
    LEFT JOIN
        user_communities AS uc ON c.id = uc.community_id AND uc.user_id = current_user_id
    LEFT JOIN
        comment_data AS cd ON p.id = cd.post_id
    WHERE
        p.id = current_post_id
    GROUP BY
        p.id, u.id, c.id, uc.user_id;
END;
$$;

-- Function: get_posts_according_to_community_id
CREATE OR REPLACE FUNCTION get_posts_according_to_community_id(current_community_id uuid, current_user_id text)
RETURNS SETOF record LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.title,
        p.content::text,
        p.image_url::text,
        p.document_url::text,
        json_build_object(
            'id', u.id,
            'name', u.name,
            'image_url', u.image_url
        ) AS author,
        json_build_object(
            'id', c.id,
            'name', c.name,
            'description', c.description,
            'image_url', c.image_url,
            'owner_id', c.owner_id,
            'is_member', CASE WHEN uc.user_id IS NOT NULL THEN true ELSE false END
        ) AS community,
        COUNT(DISTINCT CASE WHEN pv.vote_type = 'up' THEN pv.id END)::integer AS total_upvotes,
        COUNT(DISTINCT CASE WHEN pv.vote_type = 'down' THEN pv.id END)::integer AS total_downvotes,
        CASE
            WHEN user_vote.vote_type = 'up' THEN 'up'
            WHEN user_vote.vote_type = 'down' THEN 'down'
            ELSE null
        END AS user_vote_status,
        COUNT(DISTINCT pc.id)::integer AS total_comments,
        p.total_share_count
    FROM
        posts AS p
    LEFT JOIN
        post_votes AS pv ON p.id = pv.post_id
    LEFT JOIN
        post_votes AS user_vote ON p.id = user_vote.post_id AND user_vote.user_id = current_user_id
    LEFT JOIN
        users AS u ON p.user_id = u.id
    LEFT JOIN
        communities AS c ON p.community_id = c.id
    LEFT JOIN
        user_communities AS uc ON c.id = uc.community_id AND uc.user_id = current_user_id
    LEFT JOIN
        post_comments AS pc ON p.id = pc.post_id
    LEFT JOIN
        removed_posts AS rp ON p.id = rp.post_id
    WHERE
        p.community_id = current_community_id AND
        rp.post_id IS NULL
    GROUP BY
        p.id, u.id, c.id, user_vote.vote_type, uc.user_id;
END;
$$;

-- Function: get_posts_with_author_and_community
CREATE OR REPLACE FUNCTION get_posts_with_author_and_community(current_user_id text)
RETURNS SETOF record LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.title,
        p.content::text,
        p.image_url::text,
        p.document_url::text,
        json_build_object(
            'id', u.id,
            'name', u.name,
            'image_url', u.image_url
        ) AS author,
        json_build_object(
            'id', c.id,
            'name', c.name,
            'description', c.description,
            'image_url', c.image_url,
            'owner_id', c.owner_id,
            'is_member', CASE WHEN uc.user_id IS NOT NULL THEN true ELSE false END
        ) AS community,
        COUNT(DISTINCT CASE WHEN pv.vote_type = 'up' THEN pv.id END)::integer AS total_upvotes,
        COUNT(DISTINCT CASE WHEN pv.vote_type = 'down' THEN pv.id END)::integer AS total_downvotes,
        CASE
            WHEN user_vote.vote_type = 'up' THEN 'up'
            WHEN user_vote.vote_type = 'down' THEN 'down'
            ELSE null
        END AS user_vote_status,
        COUNT(DISTINCT pc.id)::integer AS total_comments,
        p.total_share_count
    FROM
        posts AS p
    LEFT JOIN
        post_votes AS pv ON p.id = pv.post_id
    LEFT JOIN
        post_votes AS user_vote ON p.id = user_vote.post_id AND user_vote.user_id = current_user_id
    LEFT JOIN
        users AS u ON p.user_id = u.id
    LEFT JOIN
        communities AS c ON p.community_id = c.id
    LEFT JOIN
        user_communities AS uc ON c.id = uc.community_id AND uc.user_id = current_user_id
    LEFT JOIN
        post_comments AS pc ON p.id = pc.post_id
    LEFT JOIN
        removed_posts AS rp ON p.id = rp.post_id
    WHERE
        rp.post_id IS NULL
    GROUP BY
        p.id, u.id, c.id, user_vote.vote_type, uc.user_id;
END;
$$;
