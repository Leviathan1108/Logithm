import { NextRequest, NextResponse } from 'next/server'
import { verifyToken, getUserById, AuthError } from '@/lib/auth'

export async function GET(request: NextRequest) {
  try {
    const token = request.cookies.get('auth-token')?.value

    if (!token) {
      throw new AuthError('No token provided', 401)
    }

    const { userId } = verifyToken(token)
    const user = await getUserById(userId)

    if (!user) {
      throw new AuthError('User not found', 401)
    }

    return NextResponse.json({
      success: true,
      data: { user }
    })

  } catch (error) {
    if (error instanceof AuthError) {
      return NextResponse.json({
        success: false,
        error: { message: error.message, statusCode: error.statusCode }
      }, { status: error.statusCode })
    }

    console.error('Auth verification error:', error)
    return NextResponse.json({
      success: false,
      error: { message: 'Internal server error', statusCode: 500 }
    }, { status: 500 })
  }
}