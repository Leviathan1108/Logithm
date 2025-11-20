import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { db } from './db'
import { AuthUser, LoginCredentials, SignupCredentials } from '@/types'

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production'

export class AuthError extends Error {
  constructor(message: string, public statusCode: number = 400) {
    super(message)
    this.name = 'AuthError'
  }
}

export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, 12)
}

export async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash)
}

export function generateToken(userId: string): string {
  return jwt.sign({ userId }, JWT_SECRET, { expiresIn: '7d' })
}

export function verifyToken(token: string): { userId: string } {
  try {
    return jwt.verify(token, JWT_SECRET) as { userId: string }
  } catch (error) {
    throw new AuthError('Invalid or expired token', 401)
  }
}

export async function createUser(credentials: SignupCredentials): Promise<AuthUser> {
  // Validate input
  if (!credentials.email || !credentials.username || !credentials.password) {
    throw new AuthError('All fields are required')
  }

  if (credentials.password !== credentials.confirmPassword) {
    throw new AuthError('Passwords do not match')
  }

  if (credentials.password.length < 6) {
    throw new AuthError('Password must be at least 6 characters long')
  }

  // Check if user already exists
  const existingUser = await db.user.findFirst({
    where: {
      OR: [
        { email: credentials.email },
        { username: credentials.username }
      ]
    }
  })

  if (existingUser) {
    if (existingUser.email === credentials.email) {
      throw new AuthError('Email already registered', 409)
    }
    if (existingUser.username === credentials.username) {
      throw new AuthError('Username already taken', 409)
    }
  }

  // Create user
  const passwordHash = await hashPassword(credentials.password)

  const user = await db.user.create({
    data: {
      email: credentials.email,
      username: credentials.username,
      passwordHash,
    }
  })

  return {
    id: user.id,
    email: user.email,
    username: user.username,
    avatar: user.avatar,
  }
}

export async function authenticateUser(credentials: LoginCredentials): Promise<{ user: AuthUser; token: string }> {
  // Find user by email
  const user = await db.user.findUnique({
    where: { email: credentials.email }
  })

  if (!user) {
    throw new AuthError('Invalid email or password', 401)
  }

  // Verify password
  const isValid = await verifyPassword(credentials.password, user.passwordHash)
  if (!isValid) {
    throw new AuthError('Invalid email or password', 401)
  }

  // Generate token
  const token = generateToken(user.id)

  const authUser = {
    id: user.id,
    email: user.email,
    username: user.username,
    avatar: user.avatar,
  }

  return { user: authUser, token }
}

export async function getUserById(userId: string): Promise<AuthUser | null> {
  const user = await db.user.findUnique({
    where: { id: userId }
  })

  if (!user) {
    return null
  }

  return {
    id: user.id,
    email: user.email,
    username: user.username,
    avatar: user.avatar,
  }
}

export async function updateUserAvatar(userId: string, avatar: string): Promise<AuthUser> {
  const user = await db.user.update({
    where: { id: userId },
    data: { avatar }
  })

  return {
    id: user.id,
    email: user.email,
    username: user.username,
    avatar: user.avatar,
  }
}