import { NextRequest, NextResponse } from 'next/server'
import { authenticateUser, AuthError } from '@/lib/auth'
import { LoginCredentials } from '@/types'

export async function POST(request: NextRequest) {
  try {
    const body: LoginCredentials = await request.json()

    const { user, token } = await authenticateUser(body)

    // Set HTTP-only cookie
    const response = NextResponse.json({
      success: true,
      data: { user }
    })

    response.cookies.set('auth-token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 60 * 60 * 24 * 7, // 7 days
      path: '/',
    })

    return response

  } catch (error) {
    if (error instanceof AuthError) {
      return NextResponse.json({
        success: false,
        error: { message: error.message, statusCode: error.statusCode }
      }, { status: error.statusCode })
    }

    console.error('Login error:', error)
    return NextResponse.json({
      success: false,
      error: { message: 'Internal server error', statusCode: 500 }
    }, { status: 500 })
  }
}